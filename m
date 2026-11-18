Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018067;
	b=DYrBAkPtp5sc4sh82MCvytDIN8D6xRriyG3vHJbSwnKfHVpS/j6DDuuHz08ve5a/jfqG
	 Utm8SbUVf0GBK3okLQ+Mzfnifzb4Yw+C/M1wWfd49B+HaG97r4OsCAYeX5zAyJrmgXuUX
	 lysabFNDXzWdO/Eqv0Gc6CjD3kVshkeKmJU2MZHOQjlVjqgSCrwRsv+6w7Sg3iefIKgQH
	 G1EuQYkJEd5PcpESq0bHdH8iObqUgzNLVSpM3ED9x9/Bd8bDgb9BMzyprzYO5LDyohqYj
	 IpuJU1HjMtvSy2rDh2esFofAHVgYV8Do1mWWMg/D4JbZjk+y3MZ8qAURodkqI2tJXxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tMnQUSBBLLiyi4rda2UkXccYsL4er3A1pTFPEILvqVc=;
	b=Y+RWMDRfukK4MxcTXCxCHpRDxiSPeaKitBIO54Y2BRvAA1liwTxCKPRZtCb+LAtv4xaP
	 I7T7DP+q6rz2u7+taSDvLnMYqG96xwiqnRsFpLGJs1zWAe2UTd2y5sh7VbFjquhgcR1I4
	 ga3/pJapxMmSajmuw9JBSt18qusi5vpBhuPi5TdXle6PPvuec/4SjMDkNGjrj+IcQIstu
	 Rc0E0z7uSa9f4/QvgGZnbAkJgBUOYd9DbEb0/jsxKkpRjoRdfpMNYcl4oh3kpTuGAQqyK
	 PZu/IavO9T3LI7ME61bkz1RNXsRKOapb+ZZ7CwQopBhaNLHmlGCBINUJ1UZtjo2JGMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DKqCGc15;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB52F60A382E;
	Wed, 18 Nov 2026 16:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DKqCGc15
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C28F81F000C6;
	Wed, 18 Nov 2026 16:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018067;
	bh=tMnQUSBBLLiyi4rda2UkXccYsL4er3A1pTFPEILvqVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DKqCGc15UWuZfoZsewupsWnBt6Rw9N9RcZY70dX/q4IshJPHL3tHolThpUfCUlM6D
	 VNWJrLWehOw1JjHimJmcrlyfFAhCgNyFZEWzF77WJY0CKWHby6rXhpAfCdbNOSyzBC
	 EDsstfWdcDHGu3Hdj0WrxF+Vf+OBndADafa3j4qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1108/2651] staging: media: tegra-video: fix syncpoint leak in tegra20 channel init
Date: Wed, 18 Nov 2026 15:39:08 +0100
Message-ID: <20261118150327.883905114@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Cong Nguyen <congnt264@gmail.com>

[ Upstream commit db757893500d682996f2ee9bd670f30f7fc504af ]

tegra20_channel_host1x_syncpt_init() requests two host1x syncpoints. It
stored the first one (mw ack) into chan->mw_ack_sp[0] and only then
requested the second one (frame start). If the second request failed the
function returned without releasing the first syncpoint, leaking it: the
caller tegra_channel_init() bails out with a bare "return ret" on a
syncpt init failure and does not run its free_syncpts error path (that
path only covers failures after syncpoint init has fully succeeded), and
the channel is subsequently torn down via the kfree()-only path, so
nothing ever releases the orphaned syncpoint.

Release the already-acquired syncpoint on the error path, and only
publish the syncpoints into the channel once both have been successfully
requested, so chan->mw_ack_sp[0] never holds a released handle. This
matches the handling in tegra210_channel_host1x_syncpt_init().

Fixes: 0e2c4117c351 ("staging: media: tegra-video: add CSI support for Tegra20 and Tegra30")
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Reviewed-by: Mikko Perttunen <mperttunen@nvidia.com>
Reviewed-by: Svyatoslav Ryhel <clamor95@gmail.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/tegra-video/tegra20.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/tegra-video/tegra20.c b/drivers/staging/media/tegra-video/tegra20.c
index eb1fc5b7e2cd5..cdadff98eae75 100644
--- a/drivers/staging/media/tegra-video/tegra20.c
+++ b/drivers/staging/media/tegra-video/tegra20.c
@@ -429,12 +429,13 @@ static int tegra20_channel_host1x_syncpt_init(struct tegra_vi_channel *chan)
 	if (!out_sp)
 		return dev_err_probe(vi->dev, -EBUSY, "failed to request mw ack syncpoint\n");
 
-	chan->mw_ack_sp[0] = out_sp;
-
 	fs_sp = host1x_syncpt_request(&vi->client, HOST1X_SYNCPT_CLIENT_MANAGED);
-	if (!fs_sp)
+	if (!fs_sp) {
+		host1x_syncpt_put(out_sp);
 		return dev_err_probe(vi->dev, -EBUSY, "failed to request frame start syncpoint\n");
+	}
 
+	chan->mw_ack_sp[0] = out_sp;
 	chan->frame_start_sp[0] = fs_sp;
 
 	return 0;
-- 
2.53.0



