Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2C421CC59;
	Mon,  2 Jun 2025 14:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874710; cv=none; b=PPUb1pumDtYOqSn9c4+qqYndrIjFvtO+F61vVlCt3lgbx0kgpeKHwuqG0lI9gMpt56tQk8DrrJcf58uQeqZaDjw4Jg2jP3UMxcWXMN0/QxWhilZ6sOybLmosLyd3aSZdc58ppxQQWs+T4tn6eXb7h8vOB0iDjRJHoHGC2kiqlAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874710; c=relaxed/simple;
	bh=X8jfRptw65ooNGjpeNaFWp0FQAbDG0qdRU7VS1QjU8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntVbjnd1lgMZ8Rnhx+hg27d++v6BdsrybkbB4CFbFQsHp3rYgr0+HxJuuAD385t2/GPtZIQxcLr41+v4Y7mCJGGauO9y9/2pWQYj6Unahu276+0iOLlOwWId3tAMkRFdcBO3+soxiHLvxUS/sb1q0J3IKUbvZxWQqCS3h5wwOt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PvLMz2T8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PvLMz2T8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33F2C4CEEB;
	Mon,  2 Jun 2025 14:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874710;
	bh=X8jfRptw65ooNGjpeNaFWp0FQAbDG0qdRU7VS1QjU8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PvLMz2T8/Hcfulj6Tm8XS7Rc0zQ/BdjB51npTUamRiF0dwmxToA7AenhEgyNCAxKW
	 Rzl0BshWj776fot2mGvsLmGMRNzJde/HxeLXDQXNCC3AtSXrHh3az9Gu5pweNBIgPf
	 5NF/KbtTrE4HIy7G8xs0YpCNhD2YyztEjKaBqJeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 104/204] um: Update min_low_pfn to match changes in uml_reserved
Date: Mon,  2 Jun 2025 15:47:17 +0200
Message-ID: <20250602134259.746541703@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit e82cf3051e6193f61e03898f8dba035199064d36 ]

When uml_reserved is updated, min_low_pfn must also be updated
accordingly. Otherwise, min_low_pfn will not accurately reflect
the lowest available PFN.

Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Link: https://patch.msgid.link/20250221041855.1156109-1-tiwei.btw@antgroup.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/kernel/mem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 417ff647fb377..06fb50218136d 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -49,6 +49,7 @@ void __init mem_init(void)
 	map_memory(brk_end, __pa(brk_end), uml_reserved - brk_end, 1, 1, 0);
 	memblock_free(__pa(brk_end), uml_reserved - brk_end);
 	uml_reserved = brk_end;
+	min_low_pfn = PFN_UP(__pa(uml_reserved));
 
 	/* this will put all low memory onto the freelists */
 	memblock_free_all();
-- 
2.39.5



