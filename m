Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B315F3C01;
	Tue, 27 May 2025 17:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367412; cv=none; b=ETAP2+QwXSKBV0Uuc0zJatNHFLwpn9S1ZvQCR5GK4I27xaJUCsNsKc0p2ryH5biijf3hSfbjncyvUhi5f45AEIvt5ObRzM4wiF2p2x4rpJuEBX3hCJdpXV2Ld8zPXAf2vhrs6NTNkv+YUvG1tpCY/UzJ05191zCmflVL6Ckk1Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367412; c=relaxed/simple;
	bh=Yc6YMrIBUven7Lx3TYf3b8nMyfK3l1qTV4g6WBJArOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKi2QWKDak4rGGpmzy/FdBTJGqlkFO1viAQgUHI+7QtDJSrpGOdqgrkmrrXqZMG8yU2AdQT0+7KPuPPCuTQAG2u4wtnz2Ny0YnkkucppL4ClTuUzMd0ZA3xFKl/DUPd+s2NYBTnchE/s3iyBmmUDuLay9ilg5lNW9FEHfv9Hy9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKXc19EM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKXc19EM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EAEC4CEE9;
	Tue, 27 May 2025 17:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367412;
	bh=Yc6YMrIBUven7Lx3TYf3b8nMyfK3l1qTV4g6WBJArOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKXc19EML0ekX+33h0GNcB3M/q16aj+xnkdx7GM4zkSKhodY8sVdxWbRQSDVFWVlw
	 HJXdts2+mVHfHk6EKBNASK+MEzHVhCCJ1+qkCgZouaA1jTJdOIJ7idQ/XQlKZ4HAde
	 YLqRHnF4qMF5F/QMZwJ+j4RkekSEWq+tcLZY6jlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nir Lichtman <nir@lichtman.org>,
	Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Michal Marek <michal.lkml@markovi.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 349/783] x86/build: Fix broken copy command in genimage.sh when making isoimage
Date: Tue, 27 May 2025 18:22:26 +0200
Message-ID: <20250527162527.281888439@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nir Lichtman <nir@lichtman.org>

[ Upstream commit e451630226bd09dc730eedb4e32cab1cc7155ae8 ]

Problem: Currently when running the "make isoimage" command there is an
error related to wrong parameters passed to the cp command:

  "cp: missing destination file operand after 'arch/x86/boot/isoimage/'"

This is caused because FDINITRDS is an empty array.

Solution: Check if FDINITRDS is empty before executing the "cp" command,
similar to how it is done in the case of hdimage.

Signed-off-by: Nir Lichtman <nir@lichtman.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Michal Marek <michal.lkml@markovi.net>
Link: https://lore.kernel.org/r/20250110120500.GA923218@lichtman.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/genimage.sh | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/genimage.sh b/arch/x86/boot/genimage.sh
index c9299aeb7333e..3882ead513f74 100644
--- a/arch/x86/boot/genimage.sh
+++ b/arch/x86/boot/genimage.sh
@@ -22,6 +22,7 @@
 # This script requires:
 #   bash
 #   syslinux
+#   genisoimage
 #   mtools (for fdimage* and hdimage)
 #   edk2/OVMF (for hdimage)
 #
@@ -251,7 +252,9 @@ geniso() {
 	cp "$isolinux" "$ldlinux" "$tmp_dir"
 	cp "$FBZIMAGE" "$tmp_dir"/linux
 	echo default linux "$KCMDLINE" > "$tmp_dir"/isolinux.cfg
-	cp "${FDINITRDS[@]}" "$tmp_dir"/
+	if [ ${#FDINITRDS[@]} -gt 0 ]; then
+		cp "${FDINITRDS[@]}" "$tmp_dir"/
+	fi
 	genisoimage -J -r -appid 'LINUX_BOOT' -input-charset=utf-8 \
 		    -quiet -o "$FIMAGE" -b isolinux.bin \
 		    -c boot.cat -no-emul-boot -boot-load-size 4 \
-- 
2.39.5



