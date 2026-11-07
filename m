Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061591;
	b=nOThcRlx14IwdbQtVf/NfpF1WI1p+JlmoBAOaISrGxFul1K39kgXkEf5DaNIuXdbiHt0
	 upPorz++lldhy0DaMiB/7FMZmtQbxWSz5OoiTA4xQuabKtLxtJgNEA4+YoOigL33bxdmx
	 UDpeCNQkmVVttFvRL51FRxaFMbCgv2l8ABx7HxtPLpKiRk2YwkhHz7tX79jO1k2Q6tIcc
	 dqGumT9xjgGKYFR4+o44TJWYwIWRPyJjI9ouVLSjsLf0WQAK+AIj6OSoltu8FY+38blyF
	 tXdVGvV8yYSQdeyfe79siewCh8xS7S88tIHswarqfZVgZNrSAq/QRQvAO4mMFCiUh/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N/v0PPd9tSVuRjFLkaKdrCo7L9k5Pl/1R27rLRGJEI8=;
	b=SWw4KcR+JyXfv1Dbc4R5LKpz6XVdARg95M98OxJO3ivlEqHA94BwazLHv5Xcxada/GuS
	 uSKyUIBxHC9nZzTze3SV5neRPqaaaGMNrsq83yQeeAx8uXD006EEBRj7T53ozvQk1T7kS
	 CWoibci/yGjQ/Lq1KqsuPcgLM6/uk1L1vCpRjdv76qtabqrUJoGRkAGWFI0wOM287ttIq
	 prfBvgXoM8aXHv6K+VP5qihKxzuZ7FFTTNiOhvTEkKrL96a5GJRZQlI4vV10rRecnCQgD
	 TCRRLvsJhWtz+uPe+eYNj5XhLKSm2iHV2zYNpdcadeZGcoTnBCA23AsORkFRSC0ePCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u5ycLUTJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D45C606A326;
	Sat,  7 Nov 2026 14:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u5ycLUTJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0F91F0089F;
	Sat,  7 Nov 2026 14:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061590;
	bh=N/v0PPd9tSVuRjFLkaKdrCo7L9k5Pl/1R27rLRGJEI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u5ycLUTJtWp2X3VyaUpihyRITuecu7C6OKxmby6Q7Kpv7aXmx9d8iksTZHJzqCxDi
	 IiBwbpd5k8lyVCU/hN9aelO9OsGwzVVoULRMLwognsBWMP76YO04pafkXTEw8FNbxH
	 mj/WL4/R68u4yHvXy2GnDcvItaFVRDITsVxzjoic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 0627/1536] HID: wacom: Write shared touch initial status only once
Date: Sat,  7 Nov 2026 08:44:03 -0500
Message-ID: <20261107135015.143813672@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2362,7 +2362,7 @@ static void wacom_set_shared_values(stru
 		 * match historic default.
 		 */
 		if (wacom_wac->is_soft_touch_switch)
-			wacom_wac->shared->is_touch_on = true;
+			WRITE_ONCE(wacom_wac->shared->is_touch_on, true);
 	}
 
 	if (wacom_wac->features.device_type & WACOM_DEVICETYPE_TOUCH) {


