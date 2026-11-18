Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053012;
	b=dOIoaxG06H/YnkR0Hhclg/k1a1aQ0Lo9e8kYl8XBVH5gRV+kLPgNODbiXIjkDsPQCd0U
	 U+UP1rjGlMcnH1OtygGipNatRaxmDzWX4NFVxfLUPVb+7ECwgtPfUoNI1Axcjz5u/QYDK
	 +VeI6kCKJRxLsISiwMPURzR/Dcf/ZmccCZFD/KSlLpQYtDqJBFLkZdgQhX185/K+C/O+h
	 Qi0JEHc9vfbpkC9MdD0vmds5TVRQ3eujUtuE0apXbipmswEpmxZamduzplSwViQ2T+kVS
	 Cv/jpB8sPx0UBVVtdvifPXbM3p+3bvSQF+KY1OchetOQN/RDYjzI8qMUjcCIEzkHDVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GZ360YEr9HQLdQLduR+tb5x6+ypx2pZaKbSrxk/98Zg=;
	b=qfwq4qspl+ddGaQcLbqWeIqYx7XcjArI/U3hR/oZLtBT3f9GV4LqGZulzG7iv7YE/8Iu
	 0A8YfcQ69LG4T+tmCNB74uVbV77a+qya9QewIjvmaIr2AWLm9QV+xfCo7dFJcakdAyUP+
	 sWvFqdw9S3gKsGMfqm/t7IhwCF63S0AGi2/W5QlojsLtyw1tMHzl4x5qENSv0xzVUgM3w
	 Hot9IWgUZ+yx08nSgjc1Q+Tu8DTU5amWgJI7Sj6ZfQewm7dadpcJi0yFPznspVDQU7kMf
	 ZevKMaly+N62zuk7cWZ2UL7Fb48rI4YZTAhlqZ3zJmdTHOQa83p0hA3h/6woD9JHClg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SBJkIfO7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D289B606A331;
	Thu, 19 Nov 2026 01:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SBJkIfO7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2961F000C5;
	Thu, 19 Nov 2026 01:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053012;
	bh=GZ360YEr9HQLdQLduR+tb5x6+ypx2pZaKbSrxk/98Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SBJkIfO71KIzmu0jsIRxo6KaJt5sNQKBZ6C3hEOKImhtu/SjOhQSwS7YKTIR3uwAV
	 EHU7SGSjZZglI2shSEPNAQmwU2L6WvlDp28p5t7cJGnMzvGuEetlyLJHlawJ27tO0N
	 A5fvbnaS+aC35WFH8AicwZrc20QXXDivXX/TX8ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fahad Alharbi <fahad@codepure.com>,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0767/2214] ovl: do not copy up an xattr value that was never read
Date: Wed, 18 Nov 2026 15:40:43 +0100
Message-ID: <20261118150042.377816158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit 755b5c5c9277be251a51623d6065abab948c61bc ]

Copy-up stores uninitialized kernel memory in an xattr of the upper
file, where the user can read it.

ovl_copy_xattr() may only pass bytes to ovl_do_setxattr() that
ovl_do_getxattr() has read. When the read fails with -ERANGE the
function asks for the size again, and if the new size fits the buffer
it stores the buffer although nothing was read into it. The buffer
comes from kvmalloc(), or it still holds the value of the previous
xattr.

A FUSE lower layer that answers every sized GETXATTR with -ERANGE made
copy-up store 4096 bytes that the server never sent, with a kernel
pointer in them, as an xattr of the upper file.

Fix this by failing the copy-up with -EIO when the size that follows
-ERANGE fits the buffer.

Reported-by: Fahad Alharbi <fahad@codepure.com>
Closes: https://lore.kernel.org/linux-fsdevel/CAOQ4uxjhfpNVvoVrTayj46H2CViTOc3oxzM6xdb8+E7ikE2CSA@mail.gmail.com/
Fixes: e4ad29fa0d22 ("ovl: use a minimal buffer in ovl_copy_xattr")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index cba2bf43c3c22..39cb8d225512c 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -95,8 +95,12 @@ int ovl_copy_xattr(struct super_block *sb, struct path *oldpath, struct dentry *
 		}
 retry:
 		size = ovl_do_getxattr(oldpath, name, value, value_size);
-		if (size == -ERANGE)
+		if (size == -ERANGE) {
 			size = ovl_do_getxattr(oldpath, name, NULL, 0);
+			/* Nothing was read into value, so it must not be used */
+			if (size >= 0 && size <= value_size)
+				size = -EIO;
+		}
 
 		if (size < 0) {
 			error = size;
-- 
2.53.0



