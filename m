Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC14929C339;
	Tue, 26 Aug 2025 11:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207586; cv=none; b=V+h43JcNc3uzPVosVkZDZujUtq1KeezgHNXdryYqGFp68WMoMdq1pR+/UxVNpAwHI8XvzjWTNH+spvVmKNeODPAyxjlFQsRlOHl/2pKZmR9rOQllrn/Kv37z6EegUtW895tpL3JM0Zx4petSJEqfl5OU1wsdBZq2Dm+tsAaM8gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207586; c=relaxed/simple;
	bh=eZf/SkwYoUFVo8sA7z/TbcFK2NTK6V9zPNkSMZe02AI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZrbr5hsYPuObIu4xyfEB7xg0nfjCcerJjSSSr/Gv8+7MVOWGstkTp/vV7GX4FBScw+0CW3geoXjaXxhWJNJJHH+/iEm03jCm8TcMEuUKiRrg9aVVontbeyVpc5d3L6w6CbDI5qHVUnuNYXI0aUPtmF/cmpVUVdbVH/14MVMIJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E2ySa4+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E2ySa4+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F342C4CEF1;
	Tue, 26 Aug 2025 11:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207586;
	bh=eZf/SkwYoUFVo8sA7z/TbcFK2NTK6V9zPNkSMZe02AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E2ySa4+Tkekhb69N8ry1IFtI1IsQ8chAoypOvM58Sjir0WnFo5Z+RBZhk1c10jFl0
	 vzIW8jlaw5DRJVv1l+nxV4Ct0g3LvwvWgui5W5rRq+Ays7mABE0G4QtEL5WONMh1jw
	 ClfLN0+lklaV86SeUpP5SW7ezx7l+QXucfrPeJbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Coiby Xu <coxu@redhat.com>,
	Dave Vasilevsky <dave@vasilevsky.ca>,
	Eric Biggers <ebiggers@google.com>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 239/457] kho: warn if KHO is disabled due to an error
Date: Tue, 26 Aug 2025 13:08:43 +0200
Message-ID: <20250826110943.281727118@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pasha Tatashin <pasha.tatashin@soleen.com>

commit 44958f2025ed3f29fc3e93bb1f6c16121d7847ad upstream.

During boot scratch area is allocated based on command line parameters or
auto calculated.  However, scratch area may fail to allocate, and in that
case KHO is disabled.  Currently, no warning is printed that KHO is
disabled, which makes it confusing for the end user to figure out why KHO
is not available.  Add the missing warning message.

Link: https://lkml.kernel.org/r/20250808201804.772010-4-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Coiby Xu <coxu@redhat.com>
Cc: Dave Vasilevsky <dave@vasilevsky.ca>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kexec_handover.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 65145972d6d6..ecd1ac210dbd 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -564,6 +564,7 @@ err_free_scratch_areas:
 err_free_scratch_desc:
 	memblock_free(kho_scratch, kho_scratch_cnt * sizeof(*kho_scratch));
 err_disable_kho:
+	pr_warn("Failed to reserve scratch area, disabling kexec handover\n");
 	kho_enable = false;
 }
 
-- 
2.50.1



