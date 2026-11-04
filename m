Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829696;
	b=XEEZPEbWTQl4XO8BLqS5hSmLHMP7dWYRL5h4htdmJx/YQttcXBU12OWZzOVSCFBI0NHU
	 UQ01Qm2yDRi/HOBX+ltZ745jD2IiznlXeBVhsYoV2VfUt2aNaU+ZAJhVMpaGPBTl9dERW
	 Tlpqg8I+pMxJ3PPTq38cXXUuoG9Hnb2WZ1OEHI4tqD/+aTMXVr/im1Rmc5r0fEdTaUSAJ
	 h4icViF/0ZLPkZHzpmLXOznPS0+rq84mWPbOz8L1jZmkDFZHRoO5sqVpZAyANffmiS8Fi
	 xRcBj41Io94fOPJTQAtEhRwAZZ9CK7FJkdOQfsBAYgX5Ghxo6dZMDW6nfnCTKwNPVvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=czL8Gif9WpYtpV0Tgo6WAomRJfYywQzFPWn0yq8mJjs=;
	b=E3IzqqmGwwcuPHdq/oIy7BJBpWGT3P31YssoRL5MnjhSdNyp1lYHVhOpIpqt6S1mPyHb
	 ei6pYqhQPo0GhPm5bTxAY0wpOWJs7mXGwNSn3tm70vfcrYZifd4ww9jtzSz8G+6wrCt92
	 7tzH/a0G26dglczjoUetrGWt99hzBDwMJBqW445yS2YN+3+Q80qYwx2am4tQL7vvrLBMx
	 2ZUMaGTfbb2Qw8LNyR9GY/H5lrwqAupJRMfzZzl5qKZQcDC0UBJxgBNdYUxiyrXfTBBnT
	 uGsuTZSeGFMMiOOrT3sYAwv1pdtEo+g8EfHys58qZbYBMITzT9NbcFLoMFSLdzeF4YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="McjWgC/A";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7EB6075DE9;
	Wed,  4 Nov 2026 22:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=McjWgC/A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B3F1F000C1;
	Wed,  4 Nov 2026 22:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829695;
	bh=czL8Gif9WpYtpV0Tgo6WAomRJfYywQzFPWn0yq8mJjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=McjWgC/AKpzf7cN55QKKGh1FiC0g0LfHjCfWiCREjts4gn1GFZJgAadMqnGXzHPuz
	 HOt9W0eE7RNyBY9bmlcOBDdTI7YASnBIm763YltKNbk7lorSy7wMLXG68FSgUYPEBl
	 mKQiuU7MHCmkF6Xv22EGIbKz5tY4C80CZx7GDKKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0285/1005] fs/ntfs3: Fix memory leak in indx_find_sort()
Date: Wed,  4 Nov 2026 16:00:18 -0500
Message-ID: <20261104211051.882270156@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 194491be54e1c9e4d29d3ee777b05ff031c4b670 ]

When popping a level from the index lookup stack, indx_find_sort() frees
the struct indx_node but not the index buffer it owns. Every call that
descends and then pops a level leaks that allocation.

Free n->index before freeing the node itself.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/index.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index edfcd28573ef9..03ae5a817c1b4 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1325,6 +1325,7 @@ int indx_find_sort(struct ntfs_index *indx, struct ntfs_inode *ni,
 		/* Pop one level. */
 		if (n) {
 			fnd_pop(fnd);
+			kfree(n->index);
 			kfree(n);
 		}
 
-- 
2.53.0



