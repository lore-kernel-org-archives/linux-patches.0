Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048816;
	b=x2B0kygEeLJoko+jZYD+i+wXGMQ1LXeLiLUb/aP+37C9GWthZITLCefoD9bxGZAKVPvK
	 BN/lo9gWFELDYNtAvw+fB+NanzbmYIBnoQdTCUsN6ZXB55AMXKrkj+TGRzAj2jbUAK2Qh
	 WuzTSuXefpO7r6/RL+pZW0kY3JbjKS8pMSs2gpT3xbpo6stT5b7dNuNdR31MLc5LobS2F
	 laxQxBmZTcGei5O0+hAq6El+Gy8mb2mYwzezWzrAakqt3Xq5aZK+w1lNvYIJZiHuqiUcz
	 +ChU5l8L1u89tRJ9J4hnNJUe4BCakLgMA80Ypkt+9diF3k7FMfD1WB2vuvQmEHsjJKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wrXO1XsAdAH7wJxjDzV/NQEk1Q0MXpcxGIuTryYrH4I=;
	b=ea2FphGHRAxUiAflVSnXtTElIrsX24t9BCf3B2aTpsi4INL+bgUvVt4lvCdjJkCKjcne
	 W1l14FZBzR0FjWOJiSr2xVq8Q5EEuorzaoJxzAjVY5d42LLxg2OXYgIopdhnquykFhg7N
	 D9YfaKz/SHHkiy/fcJSonXcXr7e1NjPX971/8meUmH2xOwUi44ko7F03DbEynHIF6dqiB
	 4ygP+kl3k+mYm8R2zzJ03AnB2ilRdsacEEXY21sp9pvMqFPUxCwJ7TeGOLufAi0S91Yn0
	 /vlh9CfjAaawL2E+4aucOx3td9lkqL5fdesZr1xDNArPz/8dnB73AO+P3QPlCP1Fa/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bg1MUVXx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D24606A325;
	Thu, 19 Nov 2026 00:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bg1MUVXx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFA11F000C4;
	Thu, 19 Nov 2026 00:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048816;
	bh=wrXO1XsAdAH7wJxjDzV/NQEk1Q0MXpcxGIuTryYrH4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bg1MUVXxkP2oIyjCGIS5neJnolLLPV87P/fdSdXhJUOXX0CXUSyS1urnHTEAdNqga
	 0D4IlENDPeYMLb3hV1o9w5RdgyUntebvwU59Lq5OABB5069VxmRxScwJl2aL1lNEi4
	 rtsL3yeZyaVkfT4WOmoosjqtNPVKZfqt7NE+8XPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2131/2857] clk: ti: adpll: unregister OF clock provider on remove
Date: Wed, 18 Nov 2026 15:52:45 +0100
Message-ID: <20261118150318.132677673@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 4c943ddfc24340f1b899762b1ff35c38306b7a35 ]

ti_adpll_probe() registers the driver's onecell clock provider with
of_clk_add_provider().  The remove path only frees the clock resources,
leaving the provider registered after the backing data has been torn
down.

Unregister the OF clock provider before freeing the ADPLL resources so
the provider no longer points at released driver data after device
removal.

Fixes: 21330497f303 ("clk: ti: Add support for dm814x ADPLL")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/adpll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/ti/adpll.c b/drivers/clk/ti/adpll.c
index 34d72f81a4a82..7181fc21dd664 100644
--- a/drivers/clk/ti/adpll.c
+++ b/drivers/clk/ti/adpll.c
@@ -935,6 +935,7 @@ static int ti_adpll_remove(struct platform_device *pdev)
 {
 	struct ti_adpll_data *d = dev_get_drvdata(&pdev->dev);
 
+	of_clk_del_provider(d->np);
 	ti_adpll_free_resources(d);
 
 	return 0;
-- 
2.53.0



