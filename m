Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0321F418D
	for <patches@lists.linux.dev>; Thu, 24 Apr 2025 11:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745492627; cv=none; b=fZD+uHGQs4iDuVx6WVmbcesuEF4RCMsXFuVskxoJQY0B3sRb7GCmzNMRXlaFfbutowTr0ycL9e/HSK6BVtLvKB7GFotn14p50iA8v1NsbBr8L+xxoHNq5QGbMYW6Zj6584r0yQQIwnniDredwqOQjfFi+igNvJeGWKmEH9vY+GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745492627; c=relaxed/simple;
	bh=A7aRIxDQxrduf6NSsAo53MIHR9GutTW1OcwawD0x1PE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aISkBYHI2qmVEHXEftAfd8UYmE4e6SGBkjLWxk3w4KBVUgFkCzDcU0j3w7D8dqK6aIehjeA1pdISXKUnwNhFwqSYaFbrtRXp93gCSaa9y3xD+P6H4fXnF4qRDLvYMufCZ1q3bfn1QQfGNjMYIBlg8RYvHQab6EOiUyrdbASwBbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=U3/p8omF; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="U3/p8omF"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53OAC9Rt003384
	for <patches@lists.linux.dev>; Thu, 24 Apr 2025 11:03:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	xtcq15bcZveDtJrN9AJkNlJ7tHg9tPDmaStBfTOGpKM=; b=U3/p8omFF+aR6zWA
	/BUyEfsCVhX859gnb3pKNn2EGlq8zg7K9WCYKvoLhB6oH1fc51i5Qu+WROX3UUoF
	IR+5EU023alctiDUeLLc+wQsXvduakokM7vC4sYJzqvwFpxOzd9NdFub5+2p8HZZ
	vQtEgxa6wHw6bim4DAuTBzfUjPnE7gFGwepbvznsuTZlNdMlNCsBX4isLBKhUqbc
	TPRWS4OePSxqgUeFmW5CziHaUAkXgv67Onv7wf9bCmhX17r8KzqPc5kjiTpHPp2T
	fr3UTILdQZL6Fc/khvegPVBcHfVBoaVD9AOrvuXPtUyfLQQiNn7sEuC4nVYcCnxj
	7tusLw==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 466jh0n8yg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Thu, 24 Apr 2025 11:03:43 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c760637fe5so159400985a.0
        for <patches@lists.linux.dev>; Thu, 24 Apr 2025 04:03:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745492623; x=1746097423;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xtcq15bcZveDtJrN9AJkNlJ7tHg9tPDmaStBfTOGpKM=;
        b=UxrJYwsDlbNqK/EbcPfiE8FzSOjzWCR1liR0NW4czpvyGWYcG3BmggiIipsTNrLZ+p
         I8uJFZJrpj7XI2QJqIcXH6TQ70o92bzEg5W6ouA49lSzrHcAhKYPNCnDErF3ujC6iTHv
         jqYCHGRsK2CsbZfwibbuEDzRIy2fhSU5ZueG5Alb/SZxxLK2QMm/PNPxhvg97Weqx1wr
         vZlxcbWyTzlTX5WR7WTVAq0rInA4BUi8Oqc7TKMe/TGlRHkS6nlWHaOXy+d8LTkrO0o9
         EuhM/ZZ5wD5fWdW41nuNE3tu7QVVBEa117WgEFcUm1MkWzvOIqLKK9iChUSiUDOGNar7
         LBaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmt67wCib4X36EiX+jxcBAH8HWeLOwh+l9rLzp7jZDH12ybVnyi0eG16DUr/FZdtfcnxvQaYWg@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/z9RpmtuxfWucN+432hVZ0otC82W2Ry0i6f/qhcoWc7qC7jSU
	X5aVFFkR7UnrDa9CLGt0jBVc1TU3jlm2R3FaC9KU6JQ/aZ5yc6blJ6oYVlxqWqtwHc/f9qdFBzc
	bjPBfmr/1U3R8HHBqrPgGUqCBG/26aLCZFnBOz3ozvsQME0q/CoDJQRv3
X-Gm-Gg: ASbGncuQhwkuK9eSuL4f50Evcj+BHQH7N7WpW2SVY8hq8N5Wr6prY6XdlFXZIrhABQy
	T/z1Y/paJL1VnhTH/xiD/RoQtMRSMEENsvRtH7vkHx2dE8v7OjbF0BtJpFmrenRensGUBsvGsDu
	SEhaxCrKVTv/VLJmT/gwWVRGjP2EY6t3yHP6huC/MTFJKwaJgRYq4mTYbHfP7wDpTp7JJZueskF
	TAHqZJPhqOKYRAq5Clc6KezVJ2VMKpRU/xZITVMlu9/Gq6BRCXInOqFcL0kbuOe1oNAinr/+fsJ
	5p9EqLc6S6jKZJ6+Inx240ftNxwBK9CsEZ6TEBR36YofAUDZjp6AMDfKW8Cny0Qo6owelnAel7A
	=
X-Received: by 2002:a05:620a:c4c:b0:7c5:6ba5:dd65 with SMTP id af79cd13be357-7c956f89c96mr328238385a.55.1745492623174;
        Thu, 24 Apr 2025 04:03:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHteZMGvMFSUTqYYbTjZaDrVtXlfhjZqwxSyZzrDMv5DByJy8uB+GwR+TYFTzyjT/YfuETNvw==
X-Received: by 2002:a05:620a:c4c:b0:7c5:6ba5:dd65 with SMTP id af79cd13be357-7c956f89c96mr328231685a.55.1745492622399;
        Thu, 24 Apr 2025 04:03:42 -0700 (PDT)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--7a1.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::7a1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54e7cca8de0sm193160e87.189.2025.04.24.04.03.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 04:03:41 -0700 (PDT)
Date: Thu, 24 Apr 2025 14:03:39 +0300
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>, linux-kernel@vger.kernel.org,
        patches@lists.linux.dev, Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Rob Herring <robh@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Conor Dooley <conor+dt@kernel.org>, Benson Leung <bleung@chromium.org>,
        chrome-platform@lists.linux.dev, Pin-yen Lin <treapking@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        =?utf-8?Q?=C5=81ukasz?= Bartosik <ukaszb@chromium.org>,
        Jameson Thies <jthies@google.com>,
        Andrei Kuchynski <akuchynski@chromium.org>
Subject: Re: [PATCH 7/7] platform/chrome: cros_ec_typec: Support DP muxing
Message-ID: <mu6f7ru7wrxtbjra4hu4btlztg5zfrug2wxrbylfguvrv25sjl@ywxtxioeydqh>
References: <20250416000208.3568635-1-swboyd@chromium.org>
 <20250416000208.3568635-8-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250416000208.3568635-8-swboyd@chromium.org>
X-Proofpoint-ORIG-GUID: a3rahXV-_eAYYnjPFmjbP52Q4KZYZzuB
X-Authority-Analysis: v=2.4 cv=ftfcZE4f c=1 sm=1 tr=0 ts=680a1a90 cx=c_pps a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=InMYaEMRAAAA:8 a=cm27Pg_UAAAA:8 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=VHk893xo0hp5UeZsn5AA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22 a=uQu4y5UHrBEQhWXbw-vk:22
X-Proofpoint-GUID: a3rahXV-_eAYYnjPFmjbP52Q4KZYZzuB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI0MDA3NCBTYWx0ZWRfX0sKZqH2COnOz dJULsuGKy2jaJwpWsHGoZ+0WdI7f0rRojBgXvdO2XIKcvfoVS3VOwBud36rAtg6ao52jd5yv5lv GdakbceARsFsJ5aJUP64F5SaWqEGFPBeEP+7PloQ1LGRFlYFihsy4f6A1wNNz5jUwj8h8V1zwSt
 BRlQcelhSNSfBbosGMkxsyDLcCB7Yjrj7vpBQc50YTlkBioCF1AKXp7+ghbLJto+H7WlCZDsHrU mgk00u8CqnFw8BEGoiQriPjsX5Cybu/WsikEul+CgjvZ7fU5tIwj2p2qqB4Kvr7cbounc5/7KA4 reu4Ss4jQMMHwghss2p6KW9FJ4uBTmKRYAUI04fZXDqL0xp1MgP5QOdd9LHXQZ0WKXtG27HR+C3
 fF+nHY4BQQhTgoNu3tUn+NrLOi0C5vC+3HYspODNncbuwacs0Z6gCsT7wfxPbsh3HXdwolqt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.80.40
 definitions=2025-04-24_05,2025-04-22_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 malwarescore=0 impostorscore=0 adultscore=0 spamscore=0 clxscore=1015
 priorityscore=1501 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504240074

On Tue, Apr 15, 2025 at 05:02:07PM -0700, Stephen Boyd wrote:
> Most ARM based chromebooks with two usb-c-connector nodes and one DP
> controller are muxing the DP lanes between the two USB ports. This is
> done so that the type-c ports are at least equal in capability if not
> functionality. Either an analog mux is used to steer the DP signal to
> one or the other port, or a DP bridge chip has two lanes (e.g. DP
> ML0/ML1) wired to one type-c port while the other two (e.g. DP ML2/ML3)
> are wired to another type-c port.
> 
> If a user connects a DP capable cable to both usb-c-connectors the EC
> likes to inform the AP that both ports have entered DP altmode, even
> though one of those ports can't actually display anything because the DP
> lanes aren't steered there. The answer to this problem is to look at the
> HPD bit in the EC messages. The port that isn't steered for DP won't
> ever see HPD be asserted, because the EC hides HPD state for the other
> port. This isn't a great solution though, because some EC firmwares
> don't even signal HPD state in the message at all. Oops! And it really
> does throw the whole type-c subsystem for a loop when the port has DP
> altmode present but it can't be entered properly.
> 
> Let's fix these problems by doing two things.
> 
> First, we'll only allow the port that's steered for DP to enter DP mode.
> Do that by checking the mux-gpios whenever we see that the EC tells us
> DP mode has been entered. If the mux isn't selecting this port, remove
> the flag from the message so that DP mode doesn't look to be entered.
> 
> Second, inject HPD into the EC message when the EC has busted firmware.
> In this case, DT authors add 'no-hpd' to the typec node (essentially
> only on Trogdor). Listen for HPD events from the drm_bridge and read the
> mux when HPD is asserted to figure out which port actually had HPD
> asserted on it. When the port state is processed, check the bit against
> the port and if DP mode is entered, i.e. the mux is still steering
> toward that port, check if HPD is asserted on that port and inject HPD.
> This is necessary so that the typec framework can update the HPD state
> in sysfs, and eventually call drm_connector_oob_hotplug_event() from the
> DP altmode driver.
> 
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Tzung-Bi Shih <tzungbi@kernel.org>
> Cc: <chrome-platform@lists.linux.dev>
> Cc: Pin-yen Lin <treapking@chromium.org>
> Cc: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Cc: Łukasz Bartosik <ukaszb@chromium.org>
> Cc: Jameson Thies <jthies@google.com>
> Cc: Andrei Kuchynski <akuchynski@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  drivers/platform/chrome/cros_ec_typec.c      | 115 +++++++++++++++++++
>  drivers/platform/chrome/cros_ec_typec.h      |  14 +++
>  drivers/platform/chrome/cros_typec_altmode.c |   2 +
>  3 files changed, 131 insertions(+)
> 
> diff --git a/drivers/platform/chrome/cros_ec_typec.c b/drivers/platform/chrome/cros_ec_typec.c
> index 27324cf0c0c6..10079129645d 100644
> --- a/drivers/platform/chrome/cros_ec_typec.c
> +++ b/drivers/platform/chrome/cros_ec_typec.c
> @@ -7,6 +7,7 @@
>   */
>  
>  #include <linux/acpi.h>
> +#include <linux/gpio/consumer.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_graph.h>
> @@ -427,6 +428,41 @@ static int cros_typec_init_ports(struct cros_typec_data *typec)
>  	return ret;
>  }
>  
> +static void cros_typec_dp_bridge_hpd_notify(struct drm_bridge *bridge, enum drm_connector_status status)

Okay, I can see why you've implemented the bride on your own, but I
can't say that I'm happy with it. For example, for such bridges it's
relatively easy to miss the interlace_allowed and ycbcr_420_allowed
flags (which you did). Likewise it makes it harder for Luca and other
developers to review / rework bridge lifetime.

> +{
> +	struct cros_typec_dp_bridge *dp_bridge = bridge_to_cros_typec_dp_bridge(bridge);
> +	struct cros_typec_data *typec = dp_bridge->typec_data;
> +	struct gpio_desc *mux_gpio = dp_bridge->mux_gpio;
> +	int val;
> +	DECLARE_BITMAP(orig, EC_USB_PD_MAX_PORTS);
> +	DECLARE_BITMAP(changed, EC_USB_PD_MAX_PORTS);
> +
> +	if (!mux_gpio)
> +		return;
> +
> +	/* This bridge signals HPD so it must be able to detect HPD properly */
> +	if (dp_bridge->bridge.ops & DRM_BRIDGE_OP_HPD)
> +		return;
> +
> +	bitmap_copy(orig, dp_bridge->hpd_asserted, EC_USB_PD_MAX_PORTS);
> +	bitmap_zero(changed, EC_USB_PD_MAX_PORTS);
> +
> +	if (status == connector_status_connected) {
> +		val = gpiod_get_value_cansleep(mux_gpio);
> +		if (val < 0) {
> +			dev_err(typec->dev, "Failed to read mux gpio\n");
> +			return;
> +		}
> +		__set_bit(val, changed);
> +	}
> +
> +	bitmap_copy(dp_bridge->hpd_asserted, changed, EC_USB_PD_MAX_PORTS);

This looks like a home-made reimplementation of test_and_set_bit() /
test_and_clear_bit(). Can those functions be used instead?
Or simply store GPIO value under the lock?

> +
> +	/* Refresh port state. */
> +	if (!bitmap_equal(orig, changed, EC_USB_PD_MAX_PORTS))
> +		schedule_work(&typec->port_work);
> +}
> +
>  static int cros_typec_dp_bridge_attach(struct drm_bridge *bridge,
>  				       enum drm_bridge_attach_flags flags)
>  {
> @@ -435,6 +471,7 @@ static int cros_typec_dp_bridge_attach(struct drm_bridge *bridge,
>  
>  static const struct drm_bridge_funcs cros_typec_dp_bridge_funcs = {
>  	.attach	= cros_typec_dp_bridge_attach,
> +	.hpd_notify = cros_typec_dp_bridge_hpd_notify,
>  };
>  
>  static int cros_typec_init_dp_bridge(struct cros_typec_data *typec)
> @@ -452,6 +489,11 @@ static int cros_typec_init_dp_bridge(struct cros_typec_data *typec)
>  	if (!dp_bridge)
>  		return -ENOMEM;
>  	typec->dp_bridge = dp_bridge;
> +	dp_bridge->typec_data = typec;
> +
> +	dp_bridge->mux_gpio = devm_gpiod_get_optional(dev, "mux", GPIOD_ASIS);
> +	if (IS_ERR(dp_bridge->mux_gpio))
> +		return dev_err_probe(dev, PTR_ERR(dp_bridge->mux_gpio), "failed to get mux gpio\n");
>  
>  	bridge = &dp_bridge->bridge;
>  	bridge->funcs = &cros_typec_dp_bridge_funcs;
> @@ -662,6 +704,77 @@ static int cros_typec_enable_usb4(struct cros_typec_data *typec,
>  	return typec_mux_set(port->mux, &port->state);
>  }
>  
> +/*
> + * Some ECs like to tell AP that both ports have DP enabled when that's
> + * impossible because the EC is muxing DP to one or the other port. Check the
> + * mux on the EC in this case and ignore what the EC tells us about DP on the
> + * port that isn't actually muxed for DP.
> + */
> +void cros_typec_check_dp(struct cros_typec_data *typec,
> +			 struct ec_response_usb_pd_mux_info *resp,
> +			 struct cros_typec_port *port)
> +{
> +	struct cros_typec_dp_bridge *dp_bridge = typec->dp_bridge;
> +	struct gpio_desc *mux_gpio;
> +	int val;
> +
> +	/* Never registered a drm_bridge. Skip. */
> +	if (!dp_bridge)
> +		return;
> +
> +	/* Don't need to override DP enabled when DP isn't enabled. */
> +	if (!(resp->flags & USB_PD_MUX_DP_ENABLED))
> +		return;
> +
> +	mux_gpio = dp_bridge->mux_gpio;
> +	/* EC mux is required to determine which port actually has DP on it. */
> +	if (!mux_gpio)
> +		return;
> +
> +	val = gpiod_get_value_cansleep(mux_gpio);
> +	if (val < 0) {
> +		dev_err(typec->dev, "Failed to read mux gpio\n");
> +		return;
> +	}
> +
> +	/* Only the muxed port can have DP enabled. Ignore. */
> +	if (val != port->port_num)
> +		resp->flags &= ~USB_PD_MUX_DP_ENABLED;
> +}
> +
> +/*
> + * Some ECs don't notify AP when HPD goes high or low because their firmware is
> + * broken. Capture the state of HPD in cros_typec_dp_bridge_hpd_notify() and
> + * inject the asserted state into the EC's response (deasserted is the
> + * default).
> + */
> +static void cros_typec_inject_hpd(struct cros_typec_data *typec,
> +				  struct ec_response_usb_pd_mux_info *resp,
> +				  struct cros_typec_port *port)
> +{
> +	struct cros_typec_dp_bridge *dp_bridge = typec->dp_bridge;
> +
> +	/* Never registered a drm_bridge. Skip. */
> +	if (!dp_bridge)
> +		return;
> +
> +	/* Don't need to inject HPD level when DP isn't enabled. */
> +	if (!(resp->flags & USB_PD_MUX_DP_ENABLED))
> +		return;
> +
> +	/* This bridge signals HPD so it doesn't need to be reinjected */
> +	if (dp_bridge->bridge.ops & DRM_BRIDGE_OP_HPD)
> +		return;
> +
> +	/*
> +	 * The default setting is HPD deasserted. Ignore if nothing to inject.
> +	 */
> +	if (!test_bit(port->port_num, dp_bridge->hpd_asserted))
> +		return;
> +
> +	resp->flags |= USB_PD_MUX_HPD_LVL;
> +}
> +
>  static int cros_typec_configure_mux(struct cros_typec_data *typec, int port_num,
>  				struct ec_response_usb_pd_control_v2 *pd_ctrl)
>  {
> @@ -682,6 +795,8 @@ static int cros_typec_configure_mux(struct cros_typec_data *typec, int port_num,
>  			 port_num, ret);
>  		return ret;
>  	}
> +	cros_typec_check_dp(typec, &resp, port);
> +	cros_typec_inject_hpd(typec, &resp, port);
>  
>  	/* No change needs to be made, let's exit early. */
>  	if (port->mux_flags == resp.flags && port->role == pd_ctrl->role)
> diff --git a/drivers/platform/chrome/cros_ec_typec.h b/drivers/platform/chrome/cros_ec_typec.h
> index 090f8f5c0492..b4b331aa5dc7 100644
> --- a/drivers/platform/chrome/cros_ec_typec.h
> +++ b/drivers/platform/chrome/cros_ec_typec.h
> @@ -6,6 +6,7 @@
>  #include <linux/list.h>
>  #include <linux/notifier.h>
>  #include <linux/platform_data/cros_ec_proto.h>
> +#include <linux/types.h>
>  #include <linux/usb/pd.h>
>  #include <linux/usb/role.h>
>  #include <linux/usb/typec.h>
> @@ -88,6 +89,19 @@ struct cros_typec_port {
>  
>  struct cros_typec_dp_bridge {
>  	struct drm_bridge bridge;
> +	struct cros_typec_data *typec_data;
> +	struct gpio_desc *mux_gpio;
> +	DECLARE_BITMAP(hpd_asserted, EC_USB_PD_MAX_PORTS);
>  };
>  
> +static inline struct cros_typec_dp_bridge *
> +bridge_to_cros_typec_dp_bridge(struct drm_bridge *bridge)
> +{
> +	return container_of(bridge, struct cros_typec_dp_bridge, bridge);
> +}
> +
> +void cros_typec_check_dp(struct cros_typec_data *typec,
> +			 struct ec_response_usb_pd_mux_info *resp,
> +			 struct cros_typec_port *port);
> +
>  #endif /*  __CROS_EC_TYPEC__ */
> diff --git a/drivers/platform/chrome/cros_typec_altmode.c b/drivers/platform/chrome/cros_typec_altmode.c
> index 97ca4cfabbc0..10d21da592f1 100644
> --- a/drivers/platform/chrome/cros_typec_altmode.c
> +++ b/drivers/platform/chrome/cros_typec_altmode.c
> @@ -82,6 +82,7 @@ static int cros_typec_altmode_enter(struct typec_altmode *alt, u32 *vdo)
>  		if (ret < 0)
>  			return ret;
>  
> +		cros_typec_check_dp(adata->port->typec_data, &resp, adata->port);
>  		if (!(resp.flags & flags))
>  			return -EINVAL;
>  	} else {
> @@ -147,6 +148,7 @@ static int cros_typec_altmode_exit(struct typec_altmode *alt)
>  		if (ret < 0)
>  			return ret;
>  
> +		cros_typec_check_dp(adata->port->typec_data, &resp, adata->port);
>  		if (resp.flags & flags)
>  			return -EINVAL;
>  	} else {
> -- 
> https://chromeos.dev
> 

-- 
With best wishes
Dmitry
