Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214510;
	b=cwAW0VxEhPcJS0ubi7U7lfaITgHu3AR0Z/5UrSnQJwaoE/jU8P5reedKLlw6VC78zBwU
	 3YLzoY+wLqOg0I66oyZtcskfZp6JrBOe7IhAdTfImYDvWB5W3XgM4Gc46XUgvjYYA26eH
	 Enx3sEpRattbg2FqsDCNS9VTeFezFNRnrYGTERDEpMPlo5A82ANjWu/53mo+tJEFNm2v+
	 qoliF6i2/OhDpaQhkFIVZijdhVmRrGsZHDh/xvnFJ/P5gbDk5Uiv0FldtUkjU20/NXXvt
	 gdeEbiTlbuDWu1mpzFn3YsLiVvTZhd+EYXLb+Q//l+GsI5c3+rZRl1LW2eG20scw5tA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H1Be75+ilEYyMy9Bn7uo/lPDkY+sMDnuN3zfxmoiixY=;
	b=SfhSTXzUso/U95OD/e4cwhI4i/WbUEc/1zhU4Db2583UCHAAFhguLD5Cz4xhW2ACWZc8
	 G8vRFJkIt9OL7y8XefFQCh+ltQLdcKfWtgDqyNctJ/FZkNzHGidXHgveaFRHlXVM/O1jY
	 F7Jd4cqxqDmU4ApeGIG0IriIdkpeFDSKq3P8ONewbId8JdlYmc1U+/fnfcD3p2fZwGzVl
	 nG1tyH5gbhP9wEwpl8LAUMRCp8KF93yxmuWPWyt4Xl0oi4+BH32Kppf87n0M0E3nn+1ku
	 Eyp5lG4zS1wbhcCXTfyAmzPdGGGAvC02cOgPgG0F3Ea66mXzXJb9LmMgEFWCIhvjsxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rAjz8Rvk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF72606BFBD;
	Wed, 28 Oct 2026 19:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rAjz8Rvk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF001F031E6;
	Wed, 28 Oct 2026 19:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214509;
	bh=H1Be75+ilEYyMy9Bn7uo/lPDkY+sMDnuN3zfxmoiixY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rAjz8RvkaLQHQpg/k4VDmIMO0EnPnkxPRPF7XFt4R9qf++BFjZs3Gp+EeKqvYBDbA
	 5kMG9erd40ta9WRKopL5344pH67atxmCxeeJxkwo6zkpYeEKCudycx8VNfaDYotzPQ
	 5PeY6Eecu7vHzvxa3F5GRfOuGhLrM+82Cb3to92I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiao Ni <xni@redhat.com>,
	Coly Li <colyli@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0883/1887] md/raid10: wait barrier before returning discard request with REQ_NOWAIT
Date: Wed, 28 Oct 2026 17:49:39 +0100
Message-ID: <20261028170519.514929217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiao Ni <xni@redhat.com>

[ Upstream commit 3db4404435397a345431b45f57876a3df133f3b4 ]

raid10_handle_discard should wait barrier before returning a discard bio
which has REQ_NOWAIT. And there is no need to print warning calltrace
if a discard bio has REQ_NOWAIT flag. Quality engineer usually checks
dmesg and reports error if dmesg has warning/error calltrace.

Fixes: c9aa889b035f ("md: raid10 add nowait support")
Signed-off-by: Xiao Ni <xni@redhat.com>
Acked-by: Coly Li <colyli@kernel.org>
Link: https://lore.kernel.org/linux-raid/20250306094938.48952-1-xni@redhat.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid10.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 508b461eabe88..82562c49a14e2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1676,11 +1676,10 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
 		return -EAGAIN;
 
-	if (WARN_ON_ONCE(bio->bi_opf & REQ_NOWAIT)) {
+	if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
 		bio_wouldblock_error(bio);
 		return 0;
 	}
-	wait_barrier(conf, false);
 
 	/*
 	 * Check reshape again to avoid reshape happens after checking
-- 
2.53.0



