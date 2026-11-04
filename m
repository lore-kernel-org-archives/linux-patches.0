Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831428;
	b=BCGvm6jZLw7P/A5Rld6Wax9cF8RiEP6wgUK8XYklucY2i66wycbsUInM5r1xc5X//7JO
	 Gdx7ND1YEpnJU0UrmoYrYaXlwfeHT8efauAzJk+dqtPBhhLQstLx57K0BsDFpp3JPVpjt
	 kCOUa3Ubd7dm+CRkg1kX3qItt/+6bzkec3u5uBl5vsvN2wT2ydsysmGi6Z0wS9yqB1I5j
	 YKx7fOLoosYpRh3q+OovDOy0W0Tj5oIQ/IENFQNDSGmmrs5SxBiZ440YvOcmCrPeqpJ9G
	 JOibrY+0+CAxUiTNeWomxx3LzRGi79v53EF3UcKV9k7p7NmJBRI3H1+uUqW9FVEi7qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+toXRBsWh8RkyYcbN5bMBNSrZuPTrDOylAHR+oY99FQ=;
	b=b903EO7/Wg0YuRlQBOomESibRdOZk8RJRq/PFWIh8bUg4noAmBXArDXvpCoUTCTHdzFO
	 7TzrtjY7V6E/2dfS3QwThHTPj8CKlQtmcCcSrbYucJgvnqW9MaJeChxsPfL7q3446iHrK
	 Yp21NcwzaSPa4npgs98cgcPp0JUadbGZkS+Vjo7dqtkRJj6RlKh5180IvaQTwOgC4Ii84
	 ucJ/wwgS9BJvH6nO2ovGWPPTnAxMRWpk2xLdHKDC+wt2k03+GbvzgiMriFVaERUY8xWri
	 wbpqTA1IsMiamzHxLKUkfD0IGZzgtba/0MyLkygGHvHCbZqVtNKG757Ja/fJp3mLwkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MGF9PGbD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FB6606B2D2;
	Wed,  4 Nov 2026 22:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MGF9PGbD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942D61F000C1;
	Wed,  4 Nov 2026 22:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831427;
	bh=+toXRBsWh8RkyYcbN5bMBNSrZuPTrDOylAHR+oY99FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MGF9PGbD5+RFxVNhihaC9T04noI5Xl6ANMbftwh7iGmlT7Cl6NDm3RodEnoH1HM99
	 c/P6g14C5cCy6orRMQKBRyiVecADaXMEdwAvF1Ps8J4jfHE+mnloHsHE+EXpf3gQH4
	 fFWYFLcRl8prDrjExdpvikvydrbN6qUrUH5BRSvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.18 0696/1005] HID: wacom: Write shared touch initial status only once
Date: Wed,  4 Nov 2026 16:07:09 -0500
Message-ID: <20261104211103.097244418@linuxfoundation.org>
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

From: Ping Cheng <ping.cheng@wacom.com>

commit cae3031c691dff0be61a26bc64e31a6939010d5c upstream.

For consistency with how the shared has_mute_touch_switch is handled
during registration, let's apply WRITE_ONCE to is_touch_on too.

Cc: stable@vger.kernel.org
Fixes: ba16e5ffbaa1 ("HID: wacom: Advertise SW_MUTE_DEVICE capability prior to registration")
Reviewed-by: Lee Jones <lee@kernel.org>
Signed-off-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -2391,7 +2391,7 @@ static void wacom_set_shared_values(stru
 		 * match historic default.
 		 */
 		if (wacom_wac->is_soft_touch_switch)
-			wacom_wac->shared->is_touch_on = true;
+			WRITE_ONCE(wacom_wac->shared->is_touch_on, true);
 	}
 
 	if (wacom_wac->features.device_type & WACOM_DEVICETYPE_TOUCH) {


