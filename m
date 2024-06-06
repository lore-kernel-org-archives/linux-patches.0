Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D0A198A36;
	Thu,  6 Jun 2024 14:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683435; cv=none; b=Uu0Iypdkng9+iT9BdT+oA6AMGMYF4KqPGhlgHBibdYUp3uNr2hJ0b1wn0WLgdqoK745qt2s/wJfW7rZuScBVoTF28i60u8VdlQ2qqvY5alHWQLrAhPg0iWjBqq62M4eF6hgwVysqOgKQYOy79hkWd7ZMkPrz6u4R/H0AOuI7oaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683435; c=relaxed/simple;
	bh=PHe1+luYd7OTDZvsJJ59fxkKu+MdEPBQ5BzzeStM/Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V7zmQPs6MfVif2EMBFbGWDgLEvF++cbEBI0nvLankizKxBw0wIjdF4SS+YgJC0mP/2jQq7NkrzbAt1CUo58LohF/wQAGSdIuZmK8CuGa1TfTJr1EbIe0MPEE1KH20PPgXNHmc9A45+bNzaDO3jYscjRPhVj/0x98co8emV467qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrXdmYg3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrXdmYg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87702C2BD10;
	Thu,  6 Jun 2024 14:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683435;
	bh=PHe1+luYd7OTDZvsJJ59fxkKu+MdEPBQ5BzzeStM/Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrXdmYg39KVBNKlFOvRHL7iwycZHjypnS/BZ0ENDAG5YTZAGHOP5/TDF7Shr1zyUG
	 9kgCjCp/pL4BbnCcelky5J0g297E7jz80VZzgg482FBdaaT0sqykdj614pY8MGYuOA
	 vIEIcpwvNX4ybqeYbJAMik8rl4M2JiCex56Mh634=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yao <wangyao@lemote.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 380/744] modules: Drop the .export_symbol section from the final modules
Date: Thu,  6 Jun 2024 16:00:52 +0200
Message-ID: <20240606131744.663464014@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Wang Yao <wangyao@lemote.com>

[ Upstream commit 8fe51b45c5645c259f759479c374648e9dfeaa03 ]

Commit ddb5cdbafaaa ("kbuild: generate KSYMTAB entries by modpost")
forget drop the .export_symbol section from the final modules.

Fixes: ddb5cdbafaaa ("kbuild: generate KSYMTAB entries by modpost")
Signed-off-by: Wang Yao <wangyao@lemote.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/module.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/module.lds.S b/scripts/module.lds.S
index bf5bcf2836d81..89ff01a22634f 100644
--- a/scripts/module.lds.S
+++ b/scripts/module.lds.S
@@ -13,6 +13,7 @@ SECTIONS {
 	/DISCARD/ : {
 		*(.discard)
 		*(.discard.*)
+		*(.export_symbol)
 	}
 
 	__ksymtab		0 : { *(SORT(___ksymtab+*)) }
-- 
2.43.0



