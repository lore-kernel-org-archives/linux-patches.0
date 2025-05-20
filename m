Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8608A1D5CFE;
	Tue, 20 May 2025 14:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750606; cv=none; b=MBX+zDvl5STHd1QYotz1VoZT25SAF9Sf8XiyIO7ekV1TcHMdE+58MHv20y+cnniLzeFrdz8weLXJFj6dN8ulh5AItfEGeATJBEKJt1yObIlGXqyY7w4p2h0Z+NdBzVuMl9wnw7L/9PAGyXwVcmzTxCPI7MDjFkivm7Zqhp3zjd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750606; c=relaxed/simple;
	bh=lXboqQp2Oqwa547QqYYDzSc2Ci+trYWCAKrgw+QV3VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GfU7xvmfhkwLVKS2xkrOeIC/4rcBpdtDslDjx2ZBiVsgU7cat8BnrHZiduAYolts0gyrF2h7Me1IhMRSlNp2mNpatf/D5V458qJEU1fpR52ORitbbRv2EbhSuxXCq8hmE/Pjb7cwdWHaTBhCa2y4yZxRE1yyTIBqxF5wmZUowUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rVd+Ipc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rVd+Ipc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1430C4CEE9;
	Tue, 20 May 2025 14:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750606;
	bh=lXboqQp2Oqwa547QqYYDzSc2Ci+trYWCAKrgw+QV3VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rVd+Ipc8WGTt4bkf3FDh5QM+Fl+oZEDVJQ2jiIxTxXzWnuiu6M3ZQN3sY1xz4o4GE
	 9o7qRlxT4n0SutmVQOdK7bz5Sq4mnr7oOJMRr1blX5/WX2Gch/EroQPqKx/Ii+KUkP
	 /GP/dmaPCOgr5f0Wca6rhzrQ4bmZz5+otKKK8JvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Miguel Ojeda <ojeda@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.14 063/145] Revert "kbuild, rust: use -fremap-path-prefix to make paths relative"
Date: Tue, 20 May 2025 15:50:33 +0200
Message-ID: <20250520125813.048024209@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

commit 8cf5b3f836147d8d4e7c6eb4c01945b97dab8297 upstream.

This reverts commit dbdffaf50ff9cee3259a7cef8a7bd9e0f0ba9f13.

--remap-path-prefix breaks the ability of debuggers to find the source
file corresponding to object files. As there is no simple or uniform
way to specify the source directory explicitly, this breaks developers
workflows.

Revert the unconditional usage of --remap-path-prefix, equivalent to the
same change for -ffile-prefix-map in KBUILD_CPPFLAGS.

Fixes: dbdffaf50ff9 ("kbuild, rust: use -fremap-path-prefix to make paths relative")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    1 -
 1 file changed, 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -1070,7 +1070,6 @@ KBUILD_CFLAGS += -fno-builtin-wcslen
 # change __FILE__ to the relative path to the source directory
 ifdef building_out_of_srctree
 KBUILD_CPPFLAGS += $(call cc-option,-fmacro-prefix-map=$(srcroot)/=)
-KBUILD_RUSTFLAGS += --remap-path-prefix=$(srcroot)/=
 endif
 
 # include additional Makefiles when needed


