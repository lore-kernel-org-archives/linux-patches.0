Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D2A223DC1;
	Mon,  2 Jun 2025 14:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873565; cv=none; b=NK44Q+eJWw+mymMriThiFqmKoJkfpUeT+0dCrzSNZGQ8DsCflHaLShtZaUElX6UFoms/LMhGMWdSYJlDo3ChFtm6V7vvbl4IRhAUJwqu2v7FEg9OzXrmr7H1Z9PF2Q/ZzaIPBLU4a1rm5b+7+hHZu4hvRAlH9wsJkFXOYplD10o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873565; c=relaxed/simple;
	bh=wuEPJYqfOTf2u5lUQVZZF0P3AtaePVpbWbK3Hr3KdFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OMPGys8HvamRAJMSmXZdaZ6C3ZoOgEJN2yfB2Sv77C8tDEbFFXJX9GUMjk23l1ClV0moIuXu69dQQRoRh3g/vUk+1th/6UEYph2fZidCQ0fHGLgogufI3iHBRlbnHVY0aZyxOBj0+/EcZpEoueY2iGpY2/KbuLWw9/LDDusHuik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ze5p7Nf7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ze5p7Nf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1B8C4CEEB;
	Mon,  2 Jun 2025 14:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873565;
	bh=wuEPJYqfOTf2u5lUQVZZF0P3AtaePVpbWbK3Hr3KdFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ze5p7Nf7lSdrZoPMQq+FiR4Qr+TbXMXgFkCaXp7iKnxa0HYL8h+xNqNCDLL1lMsTb
	 CjbceL9YkO+wq8qoyX9K6QDNkCNzlfBEtUDx4j305xKnoBS11EwMJfSr0ZBwrNlJYS
	 1uLOoUXaRuomkNDKF9wTvPJTzDGB+a2jEisXZscs=
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
Subject: [PATCH 6.6 182/444] x86/build: Fix broken copy command in genimage.sh when making isoimage
Date: Mon,  2 Jun 2025 15:44:06 +0200
Message-ID: <20250602134348.281062811@linuxfoundation.org>
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



