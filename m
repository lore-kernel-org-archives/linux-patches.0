Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585800;
	b=sS1yL3WzkVV+e44RBzd9Bez5EfeTrUumSyr9tRgHnoG5kOUTTzKmTLtbqVVnmOkn+54S
	 h3xmijE2oru+K0VIHWncAGjmns7qq86/Q1YbB0MdPRYUPn1FW3XQWBwiKIDj2ly3WSV36
	 e45UwUSMAJ64+zrEdEFz06qBkgRqXeeDcbD+Ot4Y15800eFqIDt8GHjmriv5v0zwHBIZF
	 bRPbHXB0EB9teZVr62yvN0IND2AAKheYmGMqV51Cffk3b6pcdbPVwIlBPm9erxbYWtSA8
	 YVUF7mR4P40Twd49gDGhY4Fla8bbQy+JO+teQkGU8oXxusLgdPEDBd/cRt1nwvTF9nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wtUX1lX1tDKQLf771mQhwQOLXJxflJsvFO1Ga4ZJmFE=;
	b=42Oef7u94JXonKbyQhXCSQ6jxoG5yBGZhg4GoSZ55ZlgCLL9FD9qtedEUIy4xEvW05Zj
	 yryBpBDpvjK6VOkO1DQhuJfMpzN5H5LFnEGoyeTu68fS+BRpkN0gKc3wME99SoS3KPtd2
	 MV1mlacL/sZD0jWKgMz6xOsCGvl1/tGGwA45Pner36ugL413XUzk9SaW78oK9qVAkB2+L
	 i2u71S71UAeWNFpgcjdNCA9JVYzc2tKUfB7GgnhwUDavUXajGTSAFRI3UP8V/jGOmj3Ys
	 FN5A5W7uboNgjpEWn2Lx1F+Hqm6LseZKf9u57PZWM2VEs0dggFN4SD9/x1BBhvi1roQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iBnu9HzU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EB0606BA99;
	Fri, 13 Nov 2026 16:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iBnu9HzU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2223E1F000C4;
	Fri, 13 Nov 2026 16:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585800;
	bh=wtUX1lX1tDKQLf771mQhwQOLXJxflJsvFO1Ga4ZJmFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iBnu9HzUCKSsOdgXXna1MUa5D05I76SBsSB6BL3jARmLe7MyUqZjsTFRE7EGRdgGw
	 MVE57YXf6e+8Ys81KYa254dyuH9+ewMPu9knTlmjEofg4maG4qwPcPEXvO4CKgWZdK
	 qqZWsoxUodrzJJcRnnI0XyzY7Bb0AJez5orNhxZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <yi1.lai@intel.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 386/507] selftests/fscontext_ns: expect EINVAL for overlay descendant userns create
Date: Fri, 13 Nov 2026 10:51:30 -0500
Message-ID: <20261113153809.562534207@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit db1c5da238dc80a61ab429a7b71b0e2835766c45 ]

Commit a518e63c3775 ("ovl: return EINVAL instead of EIO in case of
mismatched user_ns") changed the errno for completing an overlay
fscontext from another user namespace. Update the overlay test variant
to match binfmt_misc.

Reported-by: kernel test robot <yi1.lai@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202611020115.2281e158-lkp@intel.com
Fixes: a518e63c3775 ("ovl: return EINVAL instead of EIO in case of mismatched user_ns")
Cc: stable@vger.kernel.org
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/filesystems/fscontext_ns/fscontext_ns_test.c      | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/filesystems/fscontext_ns/fscontext_ns_test.c b/tools/testing/selftests/filesystems/fscontext_ns/fscontext_ns_test.c
index 0f30a3e6e197d..535bf1f4e1a30 100644
--- a/tools/testing/selftests/filesystems/fscontext_ns/fscontext_ns_test.c
+++ b/tools/testing/selftests/filesystems/fscontext_ns/fscontext_ns_test.c
@@ -193,7 +193,7 @@ FIXTURE_VARIANT_ADD(fscontext_ns, binfmt_misc) {
 
 FIXTURE_VARIANT_ADD(fscontext_ns, overlay) {
 	.fsname = "overlay",
-	.expected_errno = EIO,
+	.expected_errno = EINVAL,
 };
 
 TEST_F(fscontext_ns, create_from_descendant_userns)
-- 
2.53.0



