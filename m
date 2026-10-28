Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212567;
	b=cuPyRmiysWAlULGze1uJOOh9YzpXDTB1NucNzvw2+oGpYd4mRJXij0pnO5T5JjWIehqa
	 QQ8WlS1FRQVKyHm5heLQpeqQ2elBn/h8PCGCeKzkaxgOEReucHKmEw+vuRjOsQPx3mSIf
	 WLfoD2EbbE5HynOI6d97Vp9BZgpiquUbIIjLSs9uI+lwpi9eQazUrKI0lhJHGiOwZM1u2
	 lOMVzB5xc3lieyfvxa88nkmnqDsvoqlSjbPAAMmtQEupfrh8rckO7kdfOmEdc7lHhmXcK
	 hpcnWpvXv2mwktWTRQdnbVv3ct/qVpp8Sx7HA1H4C6/0fvqtKB5uGL6YsnGwq6KcQGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O79oHiDNpCAfbATvB8X79QJtIG9KVapsQF8jxm/Y6ig=;
	b=FMiRwngMgcaYeZifAqYdfO0OJyF8aIR4NzPxBIWLmZvLsjMYM7d0EzsVq7MOEVK39nkc
	 wm/jNMcB/wG98AfGaG8t0/OtQR46MCGaT4NMKykUxUBW5/ZPtEHEtonKdn13xo1tT82xB
	 1OqROud8qgGCyEHx7RyWLAkZB/3O06ezK4pW6TZA06xW27pjRscA+EPehObbNO6nEWCJy
	 zmG7j+SGdrI/vH0qMw8Qc0CXhkfwNIHOUkvbpG6kknUPd1r13k4veLttoI4tvGCn59BBO
	 J/ReP9nr7XP3IlOUE/qpy0oezKmxXnuab0sCCPanlrg527gDo2zb+T9PJNvH+jpLVLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yRSSA+Xf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A36606A31D;
	Wed, 28 Oct 2026 18:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yRSSA+Xf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A541F01825;
	Wed, 28 Oct 2026 18:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212566;
	bh=O79oHiDNpCAfbATvB8X79QJtIG9KVapsQF8jxm/Y6ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yRSSA+XfgmfytNatUH741PvUBJ/mYRROCAZjiqNwWWHdx+GZeytT/0RD2fwWsTxyk
	 s68gBXs0NkR0qv3x607o/spfnPyZCzC+DmhM3FXMnC50neVuL3WdnEI7NlWf899rIi
	 sHNIquY9jC0SVzjSsGYhayBAHX5NHlXVWB1M27Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0197/1887] ethtool: fail closed if we cant get max channel used in indirection tables
Date: Wed, 28 Oct 2026 17:38:13 +0100
Message-ID: <20261028170503.718544251@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 2899d58462ba868287d6ff3acad3675e7adf934f ]

Commit 0d1b7d6c9274 ("bnxt: fix crashes when reducing ring count with
active RSS contexts") proves that allowing indirection table to contain
channels with out of bounds IDs may lead to crashes. Currently the
max channel check in the core gets skipped if driver can't fetch
the indirection table or when we can't allocate memory.

Both of those conditions should be extremely rare but if they do
happen we should try to be safe and fail the channel change.

[ Backport to 6.1.y: kept the older int-returning
  ethtool_get_max_rxfh_channel() and propagated its errors at both
  channel-change call sites instead of the upstream u32/U32_MAX
  conversion. A failure now returns the helper's errno (-ENOMEM or the
  driver's get_rxfh() error) rather than -EINVAL, and -EOPNOTSUPP also
  fails closed; on 6.1 IFF_RXFH_CONFIGURED can only be set via set_rxfh
  paths that require a non-zero indirection table size. ]

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20240710174043.754664-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/channels.c |  9 ++++++---
 net/ethtool/ioctl.c    | 11 +++++++----
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
index 4031588620115..05f3068ec0fe3 100644
--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -191,9 +191,12 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
 	/* ensure the new Rx count fits within the configured Rx flow
 	 * indirection table settings
 	 */
-	if (netif_is_rxfh_configured(dev) &&
-	    !ethtool_get_max_rxfh_channel(dev, &max_rx_in_use) &&
-	    (channels.combined_count + channels.rx_count) <= max_rx_in_use) {
+	if (netif_is_rxfh_configured(dev)) {
+		ret = ethtool_get_max_rxfh_channel(dev, &max_rx_in_use);
+		if (ret)
+			goto out_ops;
+	}
+	if (channels.combined_count + channels.rx_count <= max_rx_in_use) {
 		ret = -EINVAL;
 		GENL_SET_ERR_MSG(info, "requested channel counts are too low for existing indirection table settings");
 		goto out_ops;
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 1f64ff5f3f21c..439871dd1ca83 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1832,10 +1832,13 @@ static noinline_for_stack int ethtool_set_channels(struct net_device *dev,
 
 	/* ensure the new Rx count fits within the configured Rx flow
 	 * indirection table settings */
-	if (netif_is_rxfh_configured(dev) &&
-	    !ethtool_get_max_rxfh_channel(dev, &max_rx_in_use) &&
-	    (channels.combined_count + channels.rx_count) <= max_rx_in_use)
-	    return -EINVAL;
+	if (netif_is_rxfh_configured(dev)) {
+		ret = ethtool_get_max_rxfh_channel(dev, &max_rx_in_use);
+		if (ret)
+			return ret;
+	}
+	if (channels.combined_count + channels.rx_count <= max_rx_in_use)
+		return -EINVAL;
 
 	/* Disabling channels, query zero-copy AF_XDP sockets */
 	from_channel = channels.combined_count +
-- 
2.53.0



