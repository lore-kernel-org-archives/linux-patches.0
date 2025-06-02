Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0074522C32D;
	Mon,  2 Jun 2025 14:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873256; cv=none; b=eXV3XOg/fO708/oAksVJN5KTsclkHnw2i2teFAJvamJFvLPfSMa7ChxACXWr1XO57UZVS27ZogkvEAaxBkehHn3xfr49oSBtDBfYAzxnd2ZLQMr39JD18MmJ7ClQX/wA6oB2/bE3i5iPurOGX38smixTW2nClkRIwD2hbpD4k7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873256; c=relaxed/simple;
	bh=jzdgGy1g0vb1X57w3xJHAj4OowNpUwYijsMHrzY33e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1F0SEtgduDgI02czQywTBNnN3V3031tjlBv3+99i8k54kZGohEUP/Sqmbb8Q3pwpkvnmldt+S/iClEWpH/bH9ZpxJCEfrBONJf/R9N6tNjz8hhSXl1AZsI6xrdzi188WSVxxijJtDwdZTjuoIYjkZQ2OXTHkhFe2ygFKtyIxT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GyLRjxqw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GyLRjxqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AECC4CEEB;
	Mon,  2 Jun 2025 14:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873255;
	bh=jzdgGy1g0vb1X57w3xJHAj4OowNpUwYijsMHrzY33e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GyLRjxqwiSHK7pQePdnUbNa8tivzRi5CqpiFHkUxsseB6m4Kc+yowuBWMbU+KkgNT
	 FBgq6s0CSjmHAItMIrobzUjln0dw7IF8tkBe4fohmXepSlwwa+iy8PkuW0GigKdRyT
	 GqZ/oKsiDwjmLcZHwvHW93L4t+eDO32nZzEhiSrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/444] um: Update min_low_pfn to match changes in uml_reserved
Date: Mon,  2 Jun 2025 15:42:29 +0200
Message-ID: <20250602134344.347190710@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 38d5a71a579bc..f6c766b2bdf5e 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -68,6 +68,7 @@ void __init mem_init(void)
 	map_memory(brk_end, __pa(brk_end), uml_reserved - brk_end, 1, 1, 0);
 	memblock_free((void *)brk_end, uml_reserved - brk_end);
 	uml_reserved = brk_end;
+	min_low_pfn = PFN_UP(__pa(uml_reserved));
 
 	/* this will put all low memory onto the freelists */
 	memblock_free_all();
-- 
2.39.5



