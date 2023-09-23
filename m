Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3999C63B9
	for <patches@lists.linux.dev>; Sat, 23 Sep 2023 08:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E7CC433C7;
	Sat, 23 Sep 2023 08:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695457434;
	bh=tKf5MrZ+vs5fo77wMdIqWLSSEgSHaTrAwrohXJzWzww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bc1oR6NXmYpYltCOqIBaToy1DvSeAQfQtsfqTHR+Ug3jbAi5YL98G6zBH8vzantg2
	 jVz70RmiNOjLl/LtXOxAqnJcM3AKAqmg1/jKXBhOLVa+T/4iTurw3f5B/8bNUqZrQK
	 2Jbe2u6djGguSXBsgL6qWwyG4gqJC5NqAvrBU2Jc=
Date: Sat, 23 Sep 2023 10:23:52 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Salvatore Bonaccorso <carnil@debian.org>
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
Message-ID: <2023092346-gutless-skillful-f830@gregkh>
References: <20230920112826.634178162@linuxfoundation.org>
 <20230920112827.751203739@linuxfoundation.org>
 <ZQtSWm3ycmA1W7Ry@eldamar.lan>
 <ZQ0alCnaXpqWRuuQ@eldamar.lan>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZQ0alCnaXpqWRuuQ@eldamar.lan>

On Fri, Sep 22, 2023 at 06:39:48AM +0200, Salvatore Bonaccorso wrote:
> Hi Greg,
> 
> On Wed, Sep 20, 2023 at 10:13:14PM +0200, Salvatore Bonaccorso wrote:
> > Hi Greg,
> > 
> > On Wed, Sep 20, 2023 at 01:31:17PM +0200, Greg Kroah-Hartman wrote:
> > > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Uday M Bhat <uday.m.bhat@intel.com>
> > > 
> > > [ Upstream commit a14aded9299187bb17ef90700eb2cf1120ef5885 ]
> > > 
> > > For soundwire config, SSP1 is used for BT offload. This is enabled
> > > in sof_sdw_quirk_table
> > > 
> > > Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
> > > Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > > Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
> > > Signed-off-by: Uday M Bhat <uday.m.bhat@intel.com>
> > > Signed-off-by: Jairaj Arava <jairaj.arava@intel.com>
> > > Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > > Link: https://lore.kernel.org/r/20230731214257.444605-5-pierre-louis.bossart@linux.intel.com
> > > Signed-off-by: Mark Brown <broonie@kernel.org>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  sound/soc/intel/boards/sof_sdw.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
> > > index f36a0fda1b6ae..1955d277fdf20 100644
> > > --- a/sound/soc/intel/boards/sof_sdw.c
> > > +++ b/sound/soc/intel/boards/sof_sdw.c
> > > @@ -214,7 +214,9 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
> > >  			DMI_MATCH(DMI_SYS_VENDOR, "Google"),
> > >  			DMI_MATCH(DMI_PRODUCT_NAME, "Rex"),
> > >  		},
> > > -		.driver_data = (void *)(SOF_SDW_PCH_DMIC),
> > > +		.driver_data = (void *)(SOF_SDW_PCH_DMIC |
> > > +					SOF_BT_OFFLOAD_SSP(1) |
> > > +					SOF_SSP_BT_OFFLOAD_PRESENT),
> > >  	},
> > >  	/* LunarLake devices */
> > >  	{
> > > -- 
> > > 2.40.1
> > 
> > I see the following build issue while trying to check 5.10.196-rc1:
> > 
> > sound/soc/intel/boards/sof_sdw.c:218:6: error: implicit declaration of function ‘SOF_BT_OFFLOAD_SSP’ [-Werror=implicit-function-declaration]
> >   218 |      SOF_BT_OFFLOAD_SSP(1) |
> >       |      ^~~~~~~~~~~~~~~~~~
> > sound/soc/intel/boards/sof_sdw.c:219:6: error: ‘SOF_SSP_BT_OFFLOAD_PRESENT’ undeclared here (not in a function)
> >   219 |      SOF_SSP_BT_OFFLOAD_PRESENT),
> >       |      ^~~~~~~~~~~~~~~~~~~~~~~~~~
> > cc1: some warnings being treated as errors
> > make[7]: *** [scripts/Makefile.build:286: sound/soc/intel/boards/sof_sdw.o] Error 1
> 
> Would it be better to drop this patch for the 5.10.y series?
> 
> SOF_SSP_BT_OFFLOAD_PRESENT only got introduced in 19f1eace0441 ("ASoC:
> Intel: sof_sdw: add support for Bluetooth offload") in 5.14-rc1 and
> later the bit changed again in 368fa526e6e3 ("ASoC: Intel: sof_sdw:
> extends SOF_RT711_JDSRC to 4 bits") ?
> 
> Again, note I'm only the person seeing a build failure while testing
> the new RC version for 5.10.y.

Agreed, now dropped.

greg k-h
