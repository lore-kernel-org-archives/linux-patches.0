Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831939;
	b=OHPyYfAslLRR0XTNPlTTXL6V5n5G9um6hoHsMXTy3q/nKF/dVSZ7CSqYb1tigVigVq1q
	 d+rBhSigf+/XaAEMhu58w37Xuo72DHXzxtol/drPBVTC1q+9SxDvwROBUqEFaSSQkLaYT
	 PVSLUtsibXwbUmHy9JGR3L+4cimWNC/Ll8Hkek6k2SSaWPA4/sKB5IpkkdpU95y/atT7a
	 YFf6N+5fCsAPh+Fr3U/PH6qdQUh+TzZah6gMQHd7sB32702m9bkWFz3W/7zc1SUB6yNY8
	 UcmsO0cT06bvhjfMkuYHK40nmN176kmCu41G8XhbwoVu7dPLVaCwgC8/y+Z3TauL7kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831939;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HXpEtDJ7GV7lMMw+mQeO9xNclryHvzph7VupFl4sQH8=;
	b=2Bf1Wy0jQb2oe8JWy86fMVNLJTNmHOmjC85XpzgXNulwRz46YB9OewLPYWUuVUtIXfAh
	 UqMMTUtfMPALqrRDEx/+V5VvI7HnnCUHJHW0qNgPAaAb3S0JdPHTQCCsCgOgPOA/bBDx+
	 K5njHWKYZfgrYYPhNInB4qUiJy/bt16xKhY+kg1rPNbv7jzSFyw9qbPHnlb5P+jZoxTVR
	 MkmHd9IFDnRaMoQFM5haX80uKqFqyupcuCUTkZ/egsDgKNZdBoQVCxC/TecS0SGm9SmD6
	 GfjaCdcg5vWJn22qcwvGmgisTvP7E2D3vk0/H7qVF435DvWMa8EFgS5B5lNx9m7L73A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mjs47o7K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33E3606A328;
	Wed,  4 Nov 2026 22:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mjs47o7K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0C41F000C1;
	Wed,  4 Nov 2026 22:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831938;
	bh=HXpEtDJ7GV7lMMw+mQeO9xNclryHvzph7VupFl4sQH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mjs47o7Kzh1JthwSiMtN/cr6+/DjedutN44fxmH9X5TasZHaFHCscfet/jURFUpw8
	 GPySWFRRtatLX8Nk1doN0EEwlsRrnF0seT0Klw6GrB4fNTcJJJakQdi58C4E6yXXKt
	 OGxvQ87Ropg8eJh/+xRJi6yVchE8oirsUt2P/ihY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Alexander Atanasov <alex@zazolabs.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 1001/1005] selftests: ublk: add missing gitignore for metadata_size binary
Date: Wed,  4 Nov 2026 16:12:14 -0500
Message-ID: <20261104211111.061341022@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Atanasov <alex@zazolabs.com>

commit 8e5bcc3a955a2cc4460b391f55d3b49905eb248e upstream.

A new utility metadata_size was added in
commit 261b67f4e347 ("selftests: ublk: add utility to get block device metadata size")
but it was not added to .gitignore. Fix that by adding it there.

While at it sort all entries alphabetically and add a SPDX license header.

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Fixes: 261b67f4e347 ("selftests: ublk: add utility to get block device metadata size")
Signed-off-by: Alexander Atanasov <alex@zazolabs.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/ublk/.gitignore |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/ublk/.gitignore
+++ b/tools/testing/selftests/ublk/.gitignore
@@ -1,3 +1,5 @@
-kublk
-/tools
+# SPDX-License-Identifier: GPL-2.0
 *-verify.state
+/tools
+kublk
+metadata_size


