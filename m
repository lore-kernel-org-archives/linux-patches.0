Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464FE2874E1
	for <patches@lists.linux.dev>; Thu,  4 Sep 2025 20:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757018160; cv=none; b=NnNyKUFXUcyKoNGKbbujZKjMBDVW2tGdt0y78qrIEDS3bUouq3kIKKklPik4t1L0l6QduCXXRlNt6JGCL1cgebXnM3/KaSHQdst9gzjsNElYyeElp9duKtYYQ2lko3oPL8sC3W/npEHz/PPi9+Z8jwgncR1SRzocdDnHp5S+xA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757018160; c=relaxed/simple;
	bh=Q2dkN2m0NrrP9yr6dt8rb0+8X2m3TZ+GSCk/egLd/og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UUHHH79l1WRE12ZR/P8zH7K+BMW9p7dndF4uv0UWSh3HSpegsdE/E/L30bDfKBBjfaEddaH8VtaohAxTGt97KwhpFo8pwHfvnZeAZpDKbLdWEf2oZRq+2AiC/uXks5H1q/q93bHXBqDzFfmDKHS3zVZfA3RcVJ26odak4Dh/sbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GgeF3d1Y; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GgeF3d1Y"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584IM9he031829
	for <patches@lists.linux.dev>; Thu, 4 Sep 2025 20:35:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Tt589PDYtmgXBtt91hE76lALxNkXhAXljuUNCjbCoDA=; b=GgeF3d1Yz/PadKz7
	iKKXreREj7vtD0jxWfwrC801p3Wwai4LLhOGuT7obmfufrMbt9ZlG3IXWBbTg+OW
	qb1oYl+iH4K5wPEBYkqtpg2TV0mfvBWC4v4Lilm6JTOwRtvzKGEb1V2zXD5DRlAv
	nPtGFLE95gN77ZuWUPVFHgNuiY66gYYmP1T8HRurFtJKC1HDw8v/v5eB8ndMfWLi
	/xUXYEBNlrBSZOoO1j80wKeMmn005ng/uohRpgxPVhKxvRsViNfz1bDTwntG28Dx
	Uy418h2srHNPqPWC8IZZhmKleH1hMN6rMiix1O8vfMUaDT5zbwvS13+EnLK+HiAe
	2GKczg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48urw08w0h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Thu, 04 Sep 2025 20:35:58 +0000 (GMT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4b335bd70b8so25761491cf.3
        for <patches@lists.linux.dev>; Thu, 04 Sep 2025 13:35:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757018157; x=1757622957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tt589PDYtmgXBtt91hE76lALxNkXhAXljuUNCjbCoDA=;
        b=pQt5WQl0bbAmA2NSM6HME3xSlutjEqzzx6YGTlS4OlB6Q+INDFB8L4hijSzbLMGxN2
         OAjgcPZFLj2sxnaEC542JbeSqtlPSaO2Zp0vTXgMzvUQsutOBW3QzNoJeUh6v0xxvt7j
         oXN2X3DTyXBE6pEYSq9k9JnskNEr9RaiLS3EXCDZlITedXFyMzQ0Q/ySPFUPC82+rQvM
         CAGXcYMbtcdeIp9AO43Ozw9JL1HiAHrM7VZvQuALKg2myLzSBMnyRDcIHvTV9kTiwCuF
         rm+UCUqbSUTaAvolRavOQuaFktiT+gxUNiMJxM4nMURuybl1VAJGOT7ZNLE+Yxi95Wuo
         cbAw==
X-Forwarded-Encrypted: i=1; AJvYcCUb2FtAgHXAH3rUWkvwM696meO0/UJxICI4NpWEPh2478daCOyChlCfT5Fcwxq//GstJRGw8Ian@lists.linux.dev
X-Gm-Message-State: AOJu0YzpVR86KeAfUPmIuEQvR2GTko2T7cjQeytp1zE0Lm2qlSadf8qZ
	mHbyUlQ37lBDgiZ2Q9djxym4JgITqjv1hMAz2TJjLY9XV0RW9RMR5M8zDos6WQHa9s/wEL6jzAN
	QokvEi0fesq4PCgasFq2tFWqzNU0SI53xpbaX2jW8ZU6Bk0TW2e0kTSsV4ngj
X-Gm-Gg: ASbGncsZQ1nNBvR5W3+EKXdyxJum85YK7X9JCKdlNNw/1fQhDP92P2G7RyEcJWDQ2eW
	EknOpTV+21qvwWpDLtLw8I1/nA8DhSuUSMqJoFs5kHO7pnPeeDPl1baPoWfnhb81MO8UrOxKMPo
	KxkAh218Ui8mN0kbcUzmx9NR7+gQlKiNy05xisZTvMzxcIFXpd/ooHl2yi836TZvghvEeLxF42x
	FMmQvT5XCKQDeBoa2GkVd5fI7mY0WrLrcKGEqC9A1R186aZutEWec8Y6K7HTUHnu4Ed+i6oShEk
	5KipLkdnYrZ3AoP8K4kXzDK6Lp6Q+YHXHkZTlSbCxGLt/G+eG6mCwl+YOjOjhD0JDKCV6/+YHVS
	HAjqXNe3ku3YkKR5OjPoROX8D3EqBrvGFxGBedZY9TdrwsC424uwm
X-Received: by 2002:a05:622a:342:b0:4b4:9590:c1c3 with SMTP id d75a77b69052e-4b49590d088mr76501621cf.18.1757018157295;
        Thu, 04 Sep 2025 13:35:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBPbN8uDovbbXZAUwxmYfDiuXZ/b7xnAQwwFKJyQuUmCvhdF4Ek0DU61jabZ/QAgBnMMTYCQ==
X-Received: by 2002:a05:622a:342:b0:4b4:9590:c1c3 with SMTP id d75a77b69052e-4b49590d088mr76501161cf.18.1757018156640;
        Thu, 04 Sep 2025 13:35:56 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a0c3-3a00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a0c3:3a00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-337f50cbb54sm16701921fa.64.2025.09.04.13.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 13:35:55 -0700 (PDT)
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
To: Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <rfoss@kernel.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Devarsh Thakkar <devarsht@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Aradhya Bhatia <aradhya.bhatia@linux.dev>,
        Nathan Chancellor <nathan@kernel.org>
Cc: dri-devel@lists.freedesktop.org, patches@lists.linux.dev
Subject: Re: [PATCH] drm/bridge: cdns-dsi: Select VIDEOMODE_HELPERS
Date: Thu,  4 Sep 2025 23:35:51 +0300
Message-ID: <175701814843.2511186.11223011208724829948.b4-ty@oss.qualcomm.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250821-cdns-videohelpers-v1-1-853e021908cf@kernel.org>
References: <20250821-cdns-videohelpers-v1-1-853e021908cf@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: L7HnJnnEwQIV_oWfD4twTgb8ydReGXq-
X-Proofpoint-ORIG-GUID: L7HnJnnEwQIV_oWfD4twTgb8ydReGXq-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAyNyBTYWx0ZWRfXxOHvXEZff/RE
 eVolW9OY2sk9UOdUwZITZ/J2gh52IonUKVdWfYeqh1L4FBXmVcu+uGBVKhyNyfRS45a//ocoOCM
 Yv3O2IZMnQLud5fRIIXJ+jFIM+KY4mIM2yQnm9nroGo+iZWPMqbKE7PdkL7fI3XZ8PqP8dXV1oB
 jY/cLYfq7580QKaaI1uPlzD0ALDWWWjve+c58wjho3tHRJxySv/ouWhLxY5z6xXzAzHeWlGeYw3
 wpxqcucMORkNGuytTzJgwrYk4sfntQgW7WXKYyDUesJt56z2JAR8QJdJsv3JV3SxMPTv9qBuCRQ
 dj7Iny+K+jNS0CSWvv9DwJUvVxND14PI1p2z7Xm8O/8KOoldP/FZdZE/FrSEFWRDoHzOpC+/yi8
 5z+wxG81
X-Authority-Analysis: v=2.4 cv=NrDRc9dJ c=1 sm=1 tr=0 ts=68b9f82e cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GyFj89KpxmL9ovfeiVUA:9 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_07,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 malwarescore=0 priorityscore=1501 phishscore=0
 impostorscore=0 spamscore=0 bulkscore=0 adultscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508300027

On Thu, 21 Aug 2025 13:52:12 -0700, Nathan Chancellor wrote:
> When no other driver selects CONFIG_VIDEOMODE_HELPERS but
> CONFIG_DRM_CDNS_DSI is enabled, there is a linker or modpost error:
> 
>   ERROR: modpost: "drm_display_mode_to_videomode" [drivers/gpu/drm/bridge/cadence/cdns-dsi.ko] undefined!
> 
> Select VIDEOMODE_HELPERS to ensure that this helper function is
> available to the driver.
> 
> [...]

Applied to drm-misc-next, thanks!

[1/1] drm/bridge: cdns-dsi: Select VIDEOMODE_HELPERS
      commit: 28fa7f5243c02a812af50707c9805c2b57deceeb

Best regards,
-- 
With best wishes
Dmitry

