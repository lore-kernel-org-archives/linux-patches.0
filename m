Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53ED941216
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 20:13:19 +0000 (UTC)
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-32157c8e4c7so227327f8f.1
        for <patches@lists.linux.dev>; Wed, 20 Sep 2023 13:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695240797; x=1695845597; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zd8Do9SJJUDst37nmnERp+r9LxKeGK/VDgtvpwIPuCY=;
        b=UL5vVSExp31EhLy5hvpIRF1eMaKVLE/ORili9pLfjJ4Nbp3XOi7wqOSqVw1cMb/LPv
         jlcEnsmKFZGB1nvmN1c36zknqfd1ol3pADwNqqikxlhcq6mmbK38CQFaluMMsMu4l4Fh
         njwIpLg/S1eNot0V0ZkPrNVWJrABnEvp0deU0PNrzDly0yNv6qC+SX6KpwuDAz2GWF/G
         XXqPGswvGL3SJJzTQtoeul1ZAkmVOChhI+vUq+GRK2A2kva8XR7C6MTprwxjSGArDnN5
         BGOLQ+COPbNInD5LpClw3qfQg/Qw3Tv8ZVEMnmC3V6SCnmL/oJ9Bbu3JNY+5yWh3R7JO
         iDyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695240797; x=1695845597;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zd8Do9SJJUDst37nmnERp+r9LxKeGK/VDgtvpwIPuCY=;
        b=IetN1avZ3SO/sMYsY/HQepVfKu0cw94lryHB0OAa93z0Syx3N1U/cDyDDbwpJAKy6G
         vifUwBhfmUDyya6bPRm2pKZ3SJ5SgV0Fs89oesX8a1XFfkFiHD9sLI59uolw0BW7s7JZ
         TjJtdwHTHBH61O9OTF34cI9kqETddhL1iGccqhuY2vQjDskLsNIzUXJiiEHliQD+WbOj
         /JqYSp0pe/fgwqZGbF1qhH9qUVjx+V+5vIGsMeta6kdGJcFpR1P6RNM2qRvY8W8sDM2n
         swFv3W58IZT891acnte8s+rquqK2v4215s3xQthgJ8EDV+M9wAQ8q6mQkorEhx+zSHbq
         4cew==
X-Gm-Message-State: AOJu0YzEmT60Zsa9oahxQ+Bg5dZbJUXN2OwAPOuNKn2lwUdWRcbomm1X
	ohZOk7/kf1Y3AzTk+R0Yy2c=
X-Google-Smtp-Source: AGHT+IGar0PuT+VjHqU64mWQ3i2PiNibAkrooc0IjrAJPYVu/s5ByDeuaxe9SVZq4z3GLtKPFhBI6g==
X-Received: by 2002:adf:ee11:0:b0:314:350a:6912 with SMTP id y17-20020adfee11000000b00314350a6912mr3418365wrn.36.1695240797195;
        Wed, 20 Sep 2023 13:13:17 -0700 (PDT)
Received: from eldamar.lan (c-82-192-242-114.customer.ggaweb.ch. [82.192.242.114])
        by smtp.gmail.com with ESMTPSA id k1-20020adfd221000000b003217c096c1esm1390198wrh.73.2023.09.20.13.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 13:13:15 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id B7506BE2DE0; Wed, 20 Sep 2023 22:13:14 +0200 (CEST)
Date: Wed, 20 Sep 2023 22:13:14 +0200
From: Salvatore Bonaccorso <carnil@debian.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Uday M Bhat <uday.m.bhat@intel.com>,
	Jairaj Arava <jairaj.arava@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 27/83] ASoC: Intel: sof_sdw: Update BT offload
 config for soundwire config
Message-ID: <ZQtSWm3ycmA1W7Ry@eldamar.lan>
References: <20230920112826.634178162@linuxfoundation.org>
 <20230920112827.751203739@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230920112827.751203739@linuxfoundation.org>

Hi Greg,

On Wed, Sep 20, 2023 at 01:31:17PM +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Uday M Bhat <uday.m.bhat@intel.com>
> 
> [ Upstream commit a14aded9299187bb17ef90700eb2cf1120ef5885 ]
> 
> For soundwire config, SSP1 is used for BT offload. This is enabled
> in sof_sdw_quirk_table
> 
> Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
> Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
> Signed-off-by: Uday M Bhat <uday.m.bhat@intel.com>
> Signed-off-by: Jairaj Arava <jairaj.arava@intel.com>
> Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> Link: https://lore.kernel.org/r/20230731214257.444605-5-pierre-louis.bossart@linux.intel.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  sound/soc/intel/boards/sof_sdw.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
> index f36a0fda1b6ae..1955d277fdf20 100644
> --- a/sound/soc/intel/boards/sof_sdw.c
> +++ b/sound/soc/intel/boards/sof_sdw.c
> @@ -214,7 +214,9 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
>  			DMI_MATCH(DMI_SYS_VENDOR, "Google"),
>  			DMI_MATCH(DMI_PRODUCT_NAME, "Rex"),
>  		},
> -		.driver_data = (void *)(SOF_SDW_PCH_DMIC),
> +		.driver_data = (void *)(SOF_SDW_PCH_DMIC |
> +					SOF_BT_OFFLOAD_SSP(1) |
> +					SOF_SSP_BT_OFFLOAD_PRESENT),
>  	},
>  	/* LunarLake devices */
>  	{
> -- 
> 2.40.1

I see the following build issue while trying to check 5.10.196-rc1:

sound/soc/intel/boards/sof_sdw.c:218:6: error: implicit declaration of function ‘SOF_BT_OFFLOAD_SSP’ [-Werror=implicit-function-declaration]
  218 |      SOF_BT_OFFLOAD_SSP(1) |
      |      ^~~~~~~~~~~~~~~~~~
sound/soc/intel/boards/sof_sdw.c:219:6: error: ‘SOF_SSP_BT_OFFLOAD_PRESENT’ undeclared here (not in a function)
  219 |      SOF_SSP_BT_OFFLOAD_PRESENT),
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~
cc1: some warnings being treated as errors
make[7]: *** [scripts/Makefile.build:286: sound/soc/intel/boards/sof_sdw.o] Error 1

Regards,
Salvatore
