Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182C980C
	for <patches@lists.linux.dev>; Fri, 22 Sep 2023 04:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=WzZqa3rocV6baVg9nN1haYz7bTxH+VDBp3FoCoYTHuA=; b=qH4NAFKZSLK/sDp4JWBBogPpcD
	rGbuYiD4NR0Gm7nZRel+r8wUcfojHRODORb2YUgzp4Z4RQXVZzDN2vFsqBvind5fRGTUxPCdC66z+
	lnXsM1u76KplnAk8cttQ0Do3cSTcvu/dHlYGpDm6O9bbpbxa2i8U/UxixtWC7GP8bD4oG4IGoesUt
	KJkyB/rZcWOafFzt71bsYyw1OkjzKIRSIhVH998gJoRzACJNtl+RfVYbeBU7MlegtOyeymD1ZX9rg
	6VBl4bdfiBOdO/psivoybAiVYmEmWmAcAtZNEX8AQ4sZO4LLd9fQFuntZDW5XlhBY/nhATMuDvanD
	U3xEAZmQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <carnil@debian.org>)
	id 1qjXxF-00CVWl-Q6; Fri, 22 Sep 2023 04:39:50 +0000
Received: by eldamar.lan (Postfix, from userid 1000)
	id 74D08BE2DE0; Fri, 22 Sep 2023 06:39:48 +0200 (CEST)
Date: Fri, 22 Sep 2023 06:39:48 +0200
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
Message-ID: <ZQ0alCnaXpqWRuuQ@eldamar.lan>
References: <20230920112826.634178162@linuxfoundation.org>
 <20230920112827.751203739@linuxfoundation.org>
 <ZQtSWm3ycmA1W7Ry@eldamar.lan>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZQtSWm3ycmA1W7Ry@eldamar.lan>
X-Debian-User: carnil

Hi Greg,

On Wed, Sep 20, 2023 at 10:13:14PM +0200, Salvatore Bonaccorso wrote:
> Hi Greg,
> 
> On Wed, Sep 20, 2023 at 01:31:17PM +0200, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Uday M Bhat <uday.m.bhat@intel.com>
> > 
> > [ Upstream commit a14aded9299187bb17ef90700eb2cf1120ef5885 ]
> > 
> > For soundwire config, SSP1 is used for BT offload. This is enabled
> > in sof_sdw_quirk_table
> > 
> > Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
> > Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
> > Signed-off-by: Uday M Bhat <uday.m.bhat@intel.com>
> > Signed-off-by: Jairaj Arava <jairaj.arava@intel.com>
> > Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > Link: https://lore.kernel.org/r/20230731214257.444605-5-pierre-louis.bossart@linux.intel.com
> > Signed-off-by: Mark Brown <broonie@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  sound/soc/intel/boards/sof_sdw.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
> > index f36a0fda1b6ae..1955d277fdf20 100644
> > --- a/sound/soc/intel/boards/sof_sdw.c
> > +++ b/sound/soc/intel/boards/sof_sdw.c
> > @@ -214,7 +214,9 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
> >  			DMI_MATCH(DMI_SYS_VENDOR, "Google"),
> >  			DMI_MATCH(DMI_PRODUCT_NAME, "Rex"),
> >  		},
> > -		.driver_data = (void *)(SOF_SDW_PCH_DMIC),
> > +		.driver_data = (void *)(SOF_SDW_PCH_DMIC |
> > +					SOF_BT_OFFLOAD_SSP(1) |
> > +					SOF_SSP_BT_OFFLOAD_PRESENT),
> >  	},
> >  	/* LunarLake devices */
> >  	{
> > -- 
> > 2.40.1
> 
> I see the following build issue while trying to check 5.10.196-rc1:
> 
> sound/soc/intel/boards/sof_sdw.c:218:6: error: implicit declaration of function ‘SOF_BT_OFFLOAD_SSP’ [-Werror=implicit-function-declaration]
>   218 |      SOF_BT_OFFLOAD_SSP(1) |
>       |      ^~~~~~~~~~~~~~~~~~
> sound/soc/intel/boards/sof_sdw.c:219:6: error: ‘SOF_SSP_BT_OFFLOAD_PRESENT’ undeclared here (not in a function)
>   219 |      SOF_SSP_BT_OFFLOAD_PRESENT),
>       |      ^~~~~~~~~~~~~~~~~~~~~~~~~~
> cc1: some warnings being treated as errors
> make[7]: *** [scripts/Makefile.build:286: sound/soc/intel/boards/sof_sdw.o] Error 1

Would it be better to drop this patch for the 5.10.y series?

SOF_SSP_BT_OFFLOAD_PRESENT only got introduced in 19f1eace0441 ("ASoC:
Intel: sof_sdw: add support for Bluetooth offload") in 5.14-rc1 and
later the bit changed again in 368fa526e6e3 ("ASoC: Intel: sof_sdw:
extends SOF_RT711_JDSRC to 4 bits") ?

Again, note I'm only the person seeing a build failure while testing
the new RC version for 5.10.y.

Regards,
Salvatore
