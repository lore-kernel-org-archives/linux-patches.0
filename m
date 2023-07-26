Received: from abi149hd127.arn1.oracleemaildelivery.com (abi149hd127.arn1.oracleemaildelivery.com [129.149.84.127])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEE4A93A
	for <patches@lists.linux.dev>; Wed, 26 Jul 2023 23:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oci-arn1-20220924;
 d=augustwikerfors.se;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=adeXy24LwyLPD7w2tMgIdpcV0wWeY6swswqHtjOUS1E=;
 b=QFBjjb+nrYTVxk07MnTP8AI9i6bAkdHx4YupESzDL6HfH3AGXHp+/gg2W1FVXl2v8FAwwpJkCdvJ
   UqKJYJng8jCsZkOMkNuAmSA28eqzzOiCMkgGB7g1/Sby7XpMUNGhyWMGA3gvyjP3K3VeHf/fr3DU
   q0aRsxBS0i1/VUX55LC8UVb5CWIN2lEymChi0KkGcRCjI8AO1tUJgcj1jJ+tvmaGOQoRdzq984wg
   s7etIboh49c1AJglAvsX25smStTnHnKqnqEAFfwbXyinoo0j6wOjDwpxw3tciC06wNi7E1r2Hpm1
   OkiN3/RSag0nnQcdM3t+4JmksI99Zj9cnn10jw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-arn-20211201;
 d=arn1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=adeXy24LwyLPD7w2tMgIdpcV0wWeY6swswqHtjOUS1E=;
 b=Yahznc3qgH06ZEqH69Ka73YVus52i6LkjQNaGiAVz7shcyqTXVO4p++c5/3Cx5527Bxmb8Ot+vpT
   Bbctjxy4lxT9gMv8Zb7mYCjKSyWhsF0XmeaUpvJu9mVs86J4TVA8SRn42ljzA+j3rlNQ2Li+qvPi
   TuVSSh1Nm0Bh29XRc/JYqjqzwDDzrvJ5T2NOD9yCaeJHJace+Kc7/m5daK6Hj//AnPRQBEboh1R+
   sBxA3xmBYfT6f3fRyasVzneh7yjFupeEZL4blaDp69GnnxPvoD/O39jnzSqNsqdsAIHy2Zv/81V7
   Haoa3lKeF92dFNEAbRT/krprdtPsavx8VV9BLA==
Received: by omta-ad1-fd2-401-eu-stockholm-1.omtaad1.vcndparn.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230629 64bit (built Jun 29
 2023))
 with ESMTPS id <0RYF00M0KEUSHS20@omta-ad1-fd2-401-eu-stockholm-1.omtaad1.vcndparn.oraclevcn.com>
 for patches@lists.linux.dev; Wed, 26 Jul 2023 23:06:28 +0000 (GMT)
Message-id: <5fbe6ee8-f907-ffec-7c6d-400aa74eaf20@augustwikerfors.se>
Date: Thu, 27 Jul 2023 01:06:25 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-version: 1.0
From: August Wikerfors <git@augustwikerfors.se>
Subject: Re: [PATCH 6.4 102/227] ACPI: resource: Remove "Zen" specific match
 and quirks
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, evilsnoo@proton.me,
 ruinairas1992@gmail.com, nmschulte@gmail.com,
 Mario Limonciello <mario.limonciello@amd.com>,
 Werner Sembach <wse@tuxedocomputers.com>, Chuanhong Guo <gch981213@gmail.com>,
 "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
 Sasha Levin <sashal@kernel.org>
References: <20230725104514.821564989@linuxfoundation.org>
 <20230725104518.968673115@linuxfoundation.org>
Content-language: en-US
In-reply-to: <20230725104518.968673115@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Reporting-Meta:
 AAHVxkMB8SvPYfOC9e8d1PrwcKCnkwiggtN+41vRCQYWzqY8j5IHfVKfMunb/qoh
 TQL5PuhsxN3XpcD4ScJsfJHk1VBxEuKwp/4Vr+9tjpkfLbSfDEsPrPfOFs3pL7mt
 9FNX+efWJpx3EsJk2bnhc5yoTNxiMnyyIxwo3ssTK/00tWp0TlwMIJjAxUpkaOzv
 Ok8YRcP+mSi47Cll29a2/1yOiWGwN2VNWOVR2MeKaQRCVVmQVJKFQUp5PTIjuhAh
 hhA3j99xrXq4pO/r5KvWsR/rWgwWPhZRSk9ze8SnBgaNlh8PHH1BroTKHJ7Oe6Xg
 LQ2Lz6xyl3Ml5jTvDwlZrqeHqZnkk/Pnh7dtV7SY0WGRxfsoNG7Egqg4QDFP+qHM
 IGD7cGmA/83VlDxBs/bGjQRN3YT2Y0Cw6w5cddm9t/WXPGG6FA2491ic1RzAgImx AVYu

Hi,

On 2023-07-25 12:44, Greg Kroah-Hartman wrote:
> From: Mario Limonciello <mario.limonciello@amd.com>
> 
> [ Upstream commit a9c4a912b7dc7ff922d4b9261160c001558f9755 ]
> 
> commit 9946e39fe8d0 ("ACPI: resource: skip IRQ override on
> AMD Zen platforms") attempted to overhaul the override logic so it
> didn't apply on X86 AMD Zen systems.  This was intentional so that
> systems would prefer DSDT values instead of default MADT value for
> IRQ 1 on Ryzen 6000 systems which typically uses ActiveLow for IRQ1.
> 
> This turned out to be a bad assumption because several vendors
> add Interrupt Source Override but don't fix the DSDT. A pile of
> quirks was collecting that proved this wasn't sustaintable.
> 
> Furthermore some vendors have used ActiveHigh for IRQ1.
> To solve this problem revert the following commits:
> * commit 17bb7046e7ce ("ACPI: resource: Do IRQ override on all TongFang
> GMxRGxx")
> * commit f3cb9b740869 ("ACPI: resource: do IRQ override on Lenovo 14ALC7")
> * commit bfcdf58380b1 ("ACPI: resource: do IRQ override on LENOVO IdeaPad")
> * commit 7592b79ba4a9 ("ACPI: resource: do IRQ override on XMG Core 15")
> * commit 9946e39fe8d0 ("ACPI: resource: skip IRQ override on AMD Zen
> platforms")

Unfortunately this breaks the keyboard on Lenovo Yoga 7 14ARB7:
https://lore.kernel.org/all/596b9c4a-fb83-a8ab-3a44-6052d83fa546@augustwikerfors.se/
https://github.com/tomsom/yoga-linux/issues/47

Regards,
August Wikerfors
