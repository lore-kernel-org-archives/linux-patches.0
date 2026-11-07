Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065103;
	b=YRKQVg8MnxL2LIkSz/JHjZ8BxcITvWZbqBai7ofI5E1aew22/gIXmmGGfANUg8ed9OHB
	 QuS8EgguK8tQZxIWOPVcbd9sk0yaf1ImMS46n9pyan5HHQdEj9jEBep1sgzT1vB6Ug9oP
	 thpupmGDdeRKjTiZz3sa06gmE/lmkFtYoWNOYLUkSQqhoV+p9Dx6pPrVwaBOaiV/XW7ID
	 MWxq1Yyg5FJ3C0GCnVgjaFDTmlkOZ8ZPiLdN6s4WoWY3aVFRpoXRenaZkzPhB2DiNd2j2
	 pHYgEFJjnk0BHx6ZMX1Ivm4JPOjySLB/qAun81O983dwM/W28ip5VHtpqXuIy7Y295g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065103;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OiLNhztlEwxo1L9Q7GD8gANdiQWYLn/4+TFb1kbOHW8=;
	b=exuq+EcYUozV59rKlnik4XM4E7VFaEdbsPhUdPeQtQ+Lj0dyuE8Y0pZBUxcu1VyuiWaY
	 PA6zH5KEHBVHQC9w1XGJgCdDU0KJgx4cOi847sHiJYLfUHyqbu3z9GFWFyh41BaepRmhw
	 uYNgBUSb5SE5vpkqCGyDuMLRMqUu7ITrCbvgJudnf31SXXTpwIKRyos8y0g0VZWltt6Zq
	 EbC6nCCeKnEpD6r8sM0+IQN4v9gmy0w7tTGXvNjpTo6vUfS2itVIVDDxQHqcZPe1mL7Ns
	 O5jLPwzlPKqDwVCoJPK6xG04XE2H9x2cVW5QhrRpj8ZHLGJ8HfH7BZhPofKlFiAT9hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rQ1tpjVo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFB6606D801;
	Sat,  7 Nov 2026 15:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rQ1tpjVo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690B91F0089F;
	Sat,  7 Nov 2026 15:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065102;
	bh=OiLNhztlEwxo1L9Q7GD8gANdiQWYLn/4+TFb1kbOHW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rQ1tpjVoJB/OgPPATa/aBvc9rg0bizWfK2OVYZfGmwFuTPkSuP8XCrVNmiTMi23Qf
	 EL3Tj/Fiz5y1b4JuhrK2DTSjF4OS987gUqBOTjv1i6q8lSW5/aQp2ynHmREUJNPlkw
	 6anVZVlSI/cGp0n1clP6U6MX/CqVxWJrY8+cAnTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0934/1257] ntfs: do not use a stale runlist pointer when undoing $MFT extension
Date: Sat,  7 Nov 2026 08:53:50 -0500
Message-ID: <20261107135005.153527342@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Matthias Goergens <matthias.goergens@gmail.com>

[ Upstream commit 258239e79b842e5246fb7f50758d9d15430f4102 ]

When ntfs_mft_data_extend_allocation_nolock() fails after it has
rebuilt the mapping pairs of the last $MFT data extent, undo_alloc
truncates the runlist and then rebuilds the old mapping pairs from rl2,
a pointer into the runlist taken before the truncation.
ntfs_rl_truncate_nolock() can reallocate the runlist, and KASAN then
reports a use-after-free in ntfs_mapping_pairs_build().

Pass the start of the runlist instead, and hold the runlist lock for
reading while the mapping pairs are built from it.
ntfs_mapping_pairs_build() skips to the element containing the first
vcn by itself.

Fixes: 1e9ea7e04472 ("Revert "fs: Remove NTFS classic"")
Cc: stable@vger.kernel.org
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/mft.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index 8bb8b4085c8b0..892d27db22a3e 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -2023,11 +2023,16 @@ static int ntfs_mft_data_extend_allocation_nolock(struct ntfs_volume *vol)
 	if (ctx) {
 		a = ctx->attr;
 		if (mp_rebuilt && !IS_ERR(ctx->mrec)) {
-			if (ntfs_mapping_pairs_build(vol, (u8 *)a + le16_to_cpu(
+			int err;
+
+			down_read(&mft_ni->runlist.lock);
+			err = ntfs_mapping_pairs_build(vol, (u8 *)a + le16_to_cpu(
 				a->data.non_resident.mapping_pairs_offset),
 				old_alen - le16_to_cpu(
 					a->data.non_resident.mapping_pairs_offset),
-				rl2, ll, -1, NULL, NULL, NULL)) {
+				mft_ni->runlist.rl, ll, -1, NULL, NULL, NULL);
+			up_read(&mft_ni->runlist.lock);
+			if (err) {
 				ntfs_error(vol->sb, "Failed to restore mapping pairs array.%s", es);
 				NVolSetErrors(vol);
 			}
-- 
2.53.0



