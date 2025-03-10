Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D907B22AE7C;
	Mon, 10 Mar 2025 17:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629356; cv=none; b=kfZ1jSjFl3sQB+0S0Tt1cjyIF5TaKAmiRftMMvol5Dz5ZdQeMMcRUAIflLK0Y1YOcl90Y44OP1d5SSidOdoru55/LSI8jt2mjmNjnPaTJBYYsjiOBg7qLS594M3htg8VQ8CUtE5+TJI3cejCLn8U/YNtg/t0kY6h+LObXTgCupQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629356; c=relaxed/simple;
	bh=jub+bQ+hSG4mluBkUikM4L9GBk4gh4OmDUKp42lhiJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihh9mGKaaj13J+Fbr1LvPWWPUVfcG/SJQC6KRCWzPMHgfQmgID94//EVKiX6tgZ6UZt9U/j3JO4SkEx+Gd4NaH0Vg/LEOC24lLpGdyWvBDzQnZ/SYCLIgMufCxrnWSaYlSFXWY5euvi0axB5WvmwLTN9M40ofmt2g+vtcJfUFiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZ38ZbJj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZ38ZbJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56356C4CEE5;
	Mon, 10 Mar 2025 17:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629356;
	bh=jub+bQ+hSG4mluBkUikM4L9GBk4gh4OmDUKp42lhiJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZ38ZbJjrJY+ILBt1mIXftpcxZavcWjIg07cjxJl4FGe2QWpumImrt5ZLg5wnJ3j6
	 fzdtIo9+ivJE1enkODzp/qFaSEDIfExXMbYur5GPOOR0J8/wXlqFOrt5atyg1MOf4m
	 R5RIYM9mQCTsiBZNyaUsRH1Nu8Vj2Pvu0C51I08k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Juergen Gross <jgross@suse.com>,
	Jan Beulich <jbeulich@suse.com>,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 249/620] x86/xen: add FRAME_END to xen_hypercall_hvm()
Date: Mon, 10 Mar 2025 18:01:35 +0100
Message-ID: <20250310170555.455689403@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 0bd797b801bd8ee06c822844e20d73aaea0878dd ]

xen_hypercall_hvm() is missing a FRAME_END at the end, add it.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202502030848.HTNTTuo9-lkp@intel.com/
Fixes: b4845bb63838 ("x86/xen: add central hypercall functions")
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/xen-head.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 0dce73077c8cb..6105404ba5703 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -130,6 +130,7 @@ SYM_FUNC_START(xen_hypercall_hvm)
 	pop %rcx
 	pop %rax
 #endif
+	FRAME_END
 	/* Use correct hypercall function. */
 	jz xen_hypercall_amd
 	jmp xen_hypercall_intel
-- 
2.39.5



