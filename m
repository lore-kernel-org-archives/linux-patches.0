Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F005230D2B;
	Mon, 10 Mar 2025 17:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626567; cv=none; b=jSbsVt6y/dnq/1uWe89X1YR5f+MuIWBeZsAHcnxj0SmREzzQvyoUG9IzJAwAPmbtrXsIx2/yp2DPbY91AG+xseWMlLGn9JVsOD0hIEy49VBW3XYLylyUz4MzT2g229MdfZYcf8AYHuW7Qdzq6nmquUNm+GbSsSsqwNWUoBRn8DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626567; c=relaxed/simple;
	bh=hYip1oVBZBmhFUz9ES8zuQlq9kxgSE4pZ6rzrQZh/xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UzdJiob+IGpfX6e7veL/FFvjExVeSt+vojfvnkZTdU4g5lUzVs7b7p//9mAygg41oa3F9YV1PixB1jokyekJV5T9o1KDuM2+mFn7eZjWJRJtZctZetb44fOUnEsGZkudnKjHe6zAvx4/VrazKJ4w78E5tuVW3jGG+SPeLczcVpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U//h386I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U//h386I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B458C4CEE5;
	Mon, 10 Mar 2025 17:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626567;
	bh=hYip1oVBZBmhFUz9ES8zuQlq9kxgSE4pZ6rzrQZh/xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U//h386Ih+TglM4/x9RTA7jkVpV8F3+iqQusvp0IM9Qg5D6X4MuH5oqkv5xUtPYj2
	 usZmGBjevwOGLt+nuBaozBzwFirLgDOtFDyXeBWn55N6H3WQ19Jcr/bf/h4rhmvqcJ
	 9XlsSXdFJU4Xq7hLUNVw3iSJhP7Dkpn9T2xNZ4oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.13 005/207] x86/microcode/AMD: Add some forgotten models to the SHA check
Date: Mon, 10 Mar 2025 18:03:18 +0100
Message-ID: <20250310170447.967281504@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

commit 058a6bec37c6c3b826158f6d26b75de43816a880 upstream.

Add some more forgotten models to the SHA check.

Fixes: 50cef76d5cb0 ("x86/microcode/AMD: Load only SHA256-checksummed patches")
Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Toralf Förster <toralf.foerster@gmx.de>
Link: https://lore.kernel.org/r/20250307220256.11816-1-bp@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/microcode/amd.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -175,23 +175,29 @@ static bool need_sha_check(u32 cur_rev)
 {
 	switch (cur_rev >> 8) {
 	case 0x80012: return cur_rev <= 0x800126f; break;
+	case 0x80082: return cur_rev <= 0x800820f; break;
 	case 0x83010: return cur_rev <= 0x830107c; break;
 	case 0x86001: return cur_rev <= 0x860010e; break;
 	case 0x86081: return cur_rev <= 0x8608108; break;
 	case 0x87010: return cur_rev <= 0x8701034; break;
 	case 0x8a000: return cur_rev <= 0x8a0000a; break;
+	case 0xa0010: return cur_rev <= 0xa00107a; break;
 	case 0xa0011: return cur_rev <= 0xa0011da; break;
 	case 0xa0012: return cur_rev <= 0xa001243; break;
+	case 0xa0082: return cur_rev <= 0xa00820e; break;
 	case 0xa1011: return cur_rev <= 0xa101153; break;
 	case 0xa1012: return cur_rev <= 0xa10124e; break;
 	case 0xa1081: return cur_rev <= 0xa108109; break;
 	case 0xa2010: return cur_rev <= 0xa20102f; break;
 	case 0xa2012: return cur_rev <= 0xa201212; break;
+	case 0xa4041: return cur_rev <= 0xa404109; break;
+	case 0xa5000: return cur_rev <= 0xa500013; break;
 	case 0xa6012: return cur_rev <= 0xa60120a; break;
 	case 0xa7041: return cur_rev <= 0xa704109; break;
 	case 0xa7052: return cur_rev <= 0xa705208; break;
 	case 0xa7080: return cur_rev <= 0xa708009; break;
 	case 0xa70c0: return cur_rev <= 0xa70C009; break;
+	case 0xaa001: return cur_rev <= 0xaa00116; break;
 	case 0xaa002: return cur_rev <= 0xaa00218; break;
 	default: break;
 	}


