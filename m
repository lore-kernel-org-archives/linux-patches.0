Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3A911707
	for <patches@lists.linux.dev>; Sat,  9 Dec 2023 10:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=svenjoac@gmx.de header.b="mqlhZFz+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
	t=1702116356; x=1702721156; i=svenjoac@gmx.de;
	bh=O8Pt0fTqhynlfZS5mfF28bRJlrH4L54mZXkhMqYf2hQ=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:In-Reply-To:References:
	 Date;
	b=mqlhZFz+Rlt++IWyY79nPCji7prMcG6loa24qm9J40VFpKX4y6VhAO34c2yEGR/Q
	 15W3dhw80LSVixwwrtG2vJ3uUYaOMaAa2+P/GjpET3EIC7TvNBwLn+N84W6HwHYfj
	 zmAVEmtVD/GzLdcTIddhJYs9q2u2FK56Pdh+fVG/WPSliVYja0/n/WztK0MA8eqJ2
	 IHB6rqok7ymmQqA9yZbmHCWp0/LiqQG10u/UCH3bnaz+8rlBrkatlvCdRuAy3PiOq
	 W4D1Cegm+FU+6r2SimTmtAjYezwJkxsmUb83cGOyoZ1qZyOc+tcTDX6XpVpdUKgj9
	 YeF01FWPVQcGo7gnAQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from localhost.localdomain ([79.203.84.168]) by mail.gmx.net
 (mrgmx105 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1N49hB-1rL9c50pnt-01065H; Sat, 09 Dec 2023 11:05:56 +0100
Received: by localhost.localdomain (Postfix, from userid 1000)
	id C995C80096; Sat,  9 Dec 2023 11:05:53 +0100 (CET)
From: Sven Joachim <svenjoac@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org,  patches@lists.linux.dev,  Johannes Berg
 <johannes.berg@intel.com>
Subject: Re: [PATCH 6.6 074/134] wifi: cfg80211: fix CQM for non-range use
In-Reply-To: <20231205031540.189275884@linuxfoundation.org> (Greg
	Kroah-Hartman's message of "Tue, 5 Dec 2023 12:15:46 +0900")
References: <20231205031535.163661217@linuxfoundation.org>
	<20231205031540.189275884@linuxfoundation.org>
Date: Sat, 09 Dec 2023 11:05:53 +0100
Message-ID: <87sf4belmm.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:4f1JjAabCwMYnf5EGv8s8wtUgdDY7EtADSLAJ4PAShVRHtvV004
 GoxnT5DePnhuVoF889oW80YO0sPUdhAcjHeRk1iTyXp2s/iKEv8AG1xcbUytzQE13gtvWbM
 UdaNrM1hWZ9CMuu3KBtpHMXNMf5jHpb4bbLgCfMjfOKmq8h3AliISwOyv3/zo0TqSxM8rmq
 FK93gOu6dVecMwqTTrCdA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:LTIOPuHtcGY=;gVU45afvBPcJIj1AWIZwHBcOJSh
 tjXiv0AstmkrDIZdWJL9j/PQt1dCEDDGTPISz90Xe19CZJddEzjhze+kdQbKVuRUPldIXe5l0
 c6m7jfTLjTw2SBiIL/8OTtrQOEhC+zTTLsWTrR5SssyiaEwqBHCCwXPCBz+q41kCdnggGXN5Z
 665VkGWJYFQCemZvAvoGbH9o4EgEIuPZBMbTmsQ9hyb7YJhy6fJK5XHy8IHkQKIzMNpmZhyW8
 sLiOMFMLj+cK/Ht9keJ7YrS6XJB9hWS2ygtwQQaMf/OZUzhLQOQaig/UkA64Yu7+LoQRitBbs
 Ux/F82pgQPR+IJc3o3v20vl/pcVSzVOYPZ9Dl7L0tMUWIYBExZQo/NX8zSAjalmom3tpVRFsY
 z1ukH2TK+Jq44KnoH8W11sLccnNVG/cq2svLXAwwCaSiJI0QFSCKYy6pJLxIz9/17os1HS49k
 fEn4JLRCw4htgBL/bM4SVkqfezo7+Y9W0O3BaE4Mhxol9X0o6D1yqY4GxzArn3nDfdhA5kstz
 ig1xj3fsaDlpet3TIB+cKq9sdizyDXk1CBOtrENAllUmoPl7GHuRFVULCIuJ4Xc8lGVU5Wlhq
 UQ3VYmMAgcnJEo9lo7QG9suIZhtKN1yr6FtVr4xN+dOKldcxFfpV35sXWe1xyGqvKSMr1Xc+i
 4IVS2NxV70uz4GNPC6bqbkSllF2oZSKGuLXxiyghC5zxqGHHyQbDkmXnXTN9J1+ANwolABFcu
 O0j17zm8XpnK8/FLJNp9hGCB4+bksOj4IfcARBZ9z3jBNQ4HzAqgqqfvrILh4D6jNTJmQcAnM
 vVcreMyXgFyjD+/o+62M8K60SLkOMQBDlE5AERBv8juTSTE2f0fYmk9ClmqbZTsCTrv19M9BV
 /u4tFBuCvQlHyh2KPZb923ZAu2DcSiQpfpg/mekX30FewAH/NaEi3OhivJ7YvIKrEgSycLqxI
 XGFEM8+pxCXegMG55IKos9ywLnw=
Content-Transfer-Encoding: quoted-printable

On 2023-12-05 12:15 +0900, Greg Kroah-Hartman wrote:

> 6.6-stable review patch.  If anyone has any objections, please let me kn=
ow.
>
> From: Johannes Berg <johannes.berg@intel.com>
>
> commit 7e7efdda6adb385fbdfd6f819d76bc68c923c394 upstream.
>
> My prior race fix here broke CQM when ranges aren't used, as
> the reporting worker now requires the cqm_config to be set in
> the wdev, but isn't set when there's no range configured.
>
> Rather than continuing to special-case the range version, set
> the cqm_config always and configure accordingly, also tracking
> if range was used or not to be able to clear the configuration
> appropriately with the same API, which was actually not right
> if both were implemented by a driver for some reason, as is
> the case with mac80211 (though there the implementations are
> equivalent so it doesn't matter.)
>
> Also, the original multiple-RSSI commit lost checking for the
> callback, so might have potentially crashed if a driver had
> neither implementation, and userspace tried to use it despite
> not being advertised as supported.
>
> Cc: stable@vger.kernel.org
> Fixes: 4a4b8169501b ("cfg80211: Accept multiple RSSI thresholds for CQM"=
)
> Fixes: 37c20b2effe9 ("wifi: cfg80211: fix cqm_config access race")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  net/wireless/core.h    |    1
>  net/wireless/nl80211.c |   50 ++++++++++++++++++++++++++++++-----------=
--------
>  2 files changed, 32 insertions(+), 19 deletions(-)
>
> --- a/net/wireless/core.h
> +++ b/net/wireless/core.h
> @@ -299,6 +299,7 @@ struct cfg80211_cqm_config {
>  	u32 rssi_hyst;
>  	s32 last_rssi_event_value;
>  	enum nl80211_cqm_rssi_threshold_event last_rssi_event_type;
> +	bool use_range_api;
>  	int n_rssi_thresholds;
>  	s32 rssi_thresholds[] __counted_by(n_rssi_thresholds);
>  };
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -12824,10 +12824,6 @@ static int cfg80211_cqm_rssi_update(stru
>  	int i, n, low_index;
>  	int err;
>
> -	/* RSSI reporting disabled? */
> -	if (!cqm_config)
> -		return rdev_set_cqm_rssi_range_config(rdev, dev, 0, 0);
> -
>  	/*
>  	 * Obtain current RSSI value if possible, if not and no RSSI threshold
>  	 * event has been received yet, we should receive an event after a
> @@ -12902,18 +12898,6 @@ static int nl80211_set_cqm_rssi(struct g
>  	    wdev->iftype !=3D NL80211_IFTYPE_P2P_CLIENT)
>  		return -EOPNOTSUPP;
>
> -	if (n_thresholds <=3D 1 && rdev->ops->set_cqm_rssi_config) {
> -		if (n_thresholds =3D=3D 0 || thresholds[0] =3D=3D 0) /* Disabling */
> -			return rdev_set_cqm_rssi_config(rdev, dev, 0, 0);
> -
> -		return rdev_set_cqm_rssi_config(rdev, dev,
> -						thresholds[0], hysteresis);
> -	}
> -
> -	if (!wiphy_ext_feature_isset(&rdev->wiphy,
> -				     NL80211_EXT_FEATURE_CQM_RSSI_LIST))
> -		return -EOPNOTSUPP;
> -
>  	if (n_thresholds =3D=3D 1 && thresholds[0] =3D=3D 0) /* Disabling */
>  		n_thresholds =3D 0;
>
> @@ -12921,6 +12905,20 @@ static int nl80211_set_cqm_rssi(struct g
>  	old =3D rcu_dereference_protected(wdev->cqm_config,
>  					lockdep_is_held(&wdev->mtx));
>
> +	/* if already disabled just succeed */
> +	if (!n_thresholds && !old)
> +		return 0;
> +
> +	if (n_thresholds > 1) {
> +		if (!wiphy_ext_feature_isset(&rdev->wiphy,
> +					     NL80211_EXT_FEATURE_CQM_RSSI_LIST) ||
> +		    !rdev->ops->set_cqm_rssi_range_config)
> +			return -EOPNOTSUPP;
> +	} else {
> +		if (!rdev->ops->set_cqm_rssi_config)
> +			return -EOPNOTSUPP;
> +	}
> +
>  	if (n_thresholds) {
>  		cqm_config =3D kzalloc(struct_size(cqm_config, rssi_thresholds,
>  						 n_thresholds),
> @@ -12935,13 +12933,26 @@ static int nl80211_set_cqm_rssi(struct g
>  		memcpy(cqm_config->rssi_thresholds, thresholds,
>  		       flex_array_size(cqm_config, rssi_thresholds,
>  				       n_thresholds));
> +		cqm_config->use_range_api =3D n_thresholds > 1 ||
> +					    !rdev->ops->set_cqm_rssi_config;
>
>  		rcu_assign_pointer(wdev->cqm_config, cqm_config);
> +
> +		if (cqm_config->use_range_api)
> +			err =3D cfg80211_cqm_rssi_update(rdev, dev, cqm_config);
> +		else
> +			err =3D rdev_set_cqm_rssi_config(rdev, dev,
> +						       thresholds[0],
> +						       hysteresis);
>  	} else {
>  		RCU_INIT_POINTER(wdev->cqm_config, NULL);
> +		/* if enabled as range also disable via range */
> +		if (old->use_range_api)
> +			err =3D rdev_set_cqm_rssi_range_config(rdev, dev, 0, 0);
> +		else
> +			err =3D rdev_set_cqm_rssi_config(rdev, dev, 0, 0);
>  	}
>
> -	err =3D cfg80211_cqm_rssi_update(rdev, dev, cqm_config);
>  	if (err) {
>  		rcu_assign_pointer(wdev->cqm_config, old);
>  		kfree_rcu(cqm_config, rcu_head);
> @@ -19131,10 +19142,11 @@ void cfg80211_cqm_rssi_notify_work(struc
>  	wdev_lock(wdev);
>  	cqm_config =3D rcu_dereference_protected(wdev->cqm_config,
>  					       lockdep_is_held(&wdev->mtx));
> -	if (!wdev->cqm_config)
> +	if (!cqm_config)
>  		goto unlock;
>
> -	cfg80211_cqm_rssi_update(rdev, wdev->netdev, cqm_config);
> +	if (cqm_config->use_range_api)
> +		cfg80211_cqm_rssi_update(rdev, wdev->netdev, cqm_config);
>
>  	rssi_level =3D cqm_config->last_rssi_event_value;
>  	rssi_event =3D cqm_config->last_rssi_event_type;

After upgrading to 6.6.5, I noticed that my laptop would hang on
shutdown and bisected that problem to this patch.  Reverting it makes
the problem go away.

More specifically, NetworkManager and wpa_supplicant processes are hung.
This can also be triggered by "systemctl stop NetworkManager.service"
which does not complete and brings these two processes into a state of
uninterruptible sleep.

I also tried 6.1 and mainline, and could reproduce the hang in 6.1.66
but _not_ in 6.7-rc4, so maybe some patch from Linus' tree needs to be
applied to the stable branches.

Cheers,
       Sven
