Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28687A
	for <patches@lists.linux.dev>; Tue, 19 Apr 2022 06:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1650350727; x=1681886727;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8WWWeqkjRsJguwhNbQdCeYL7WvDMBr86xY9Uzcx3OXA=;
  b=o7+kp4LmWPiKTHO+UkF4pVcai1C5zoXUoyY/RhSPfcKVMI9IprdQdkUE
   mEcc6gXfu+/iW4EBCWlJRALyqJeBZCORfFXw+hc1MV9a8pZE1n7c73Kee
   QIPdjXwqHmMHpgPKVIgV3O7TI00vtwuq0/1pHgc61jQe+nUQI3im9nSno
   5ULzDffabWgmCrvTspZa0Z2aFRbOAimPGTmP6KB8Ny6+3z5INn9jur2b9
   AQaHcC+jotc1Ao1c7q30wz3HX1jlUwLuh//EjDcTW7K1UA6jc8v1zsfgA
   yzvdphSAnuwkcblVkJ3zcBSH2ug9Nn9fuDdr7BXKVPWR0UeVa3GRLqRj2
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,272,1643644800"; 
   d="scan'208";a="310208007"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Apr 2022 14:44:18 +0800
IronPort-SDR: tUGcueubEG45mr8mK1S0cSRWDGSLsdEude/KiMrS93gBnsBXsJZB2mJxczmpLooB2rwItiw/7m
 Eri7W++KFj0d+isxjs21XrHdr3bpK+jzUwUkWIfvyZxBNHDu2wf877Kr7VkizjViWeAEVaSYt9
 m8M76aKjvMj0Y/6UXeeFV+A1z8WV0/OEkpmWeuYb2MukHziR2MGqLUqbzNYNbdfMZY7/5dPYel
 Vfg4z6LuSzVV8KyHY1LHsUKyaO+NzAjuEvFk8Mk3qIpmdrcD7r4WWG2u8EfUwgrR3C3Xwf++R0
 BfhRTPVV8vcUEs1V/5jDXS1c
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Apr 2022 23:15:24 -0700
IronPort-SDR: vcKUAW6OO4VvLp/kOSBe9LOeIEMditmWz+jnNRHJBJZquU0ky2YsuZ1aP8Rgdo8HFoNysHIJV9
 +q32ZNYgX21fWgFNu9Ymw9irIPqHDknWwZDvlus23pYcWuLZv+S7ztgUpJ3+QmwF9QPzT6DJgj
 4/M+ywznjMdwZobZ+jmNUXDNR6Z4qPR+sQaurjN8ETPMSAi74Bp8quBHrNmncUzMMen6USk1jV
 yM+lskRlT34imfdRDRpCVNYrb9zFoAfhrJp0kWzXVcScS5lrCtBI0ILMjh9otQz4KiQU0rCtOl
 AOg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Apr 2022 23:44:19 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KjDmf3wS7z1SVp0
	for <patches@lists.linux.dev>; Mon, 18 Apr 2022 23:44:18 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
	reason="pass (just generated, assumed good)"
	header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
	opensource.wdc.com; h=content-transfer-encoding:content-type
	:in-reply-to:organization:from:references:to:content-language
	:subject:user-agent:mime-version:date:message-id; s=dkim; t=
	1650350657; x=1652942658; bh=8WWWeqkjRsJguwhNbQdCeYL7WvDMBr86xY9
	Uzcx3OXA=; b=rErrfmkm1eN0G90XNiKwz3BP6CTW8icQ48Osq+ekJiG4DQxQwid
	6zuPxQsa7uK/IW/QcPikMBUOlxEhg2FyYhGVfoww/j0nQ+3ywc1cCSUtsx5r7RGg
	CCczSTFxS5ZiJLygtA3jK4PeoCirK+m79Uu7q9IbR08R2P079vtIB8Ek+AwokjaN
	QZEKWDEC+tynmqWGUkJRp0asRXe50vqTEIXVvre2eAH2Y9+RDA9KbBCwsJXqd7fW
	99ND1HhAqLnRrgaE0T/Se9JEuG9CfKfsL4Gi5wbc7NqMiUn24LTOUX47mczpNPNB
	z98Vk1QBz3A2y+esuzpgZn1GNUPflMzit7A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
	by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id nJFrHGFc18qG for <patches@lists.linux.dev>;
	Mon, 18 Apr 2022 23:44:17 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
	by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KjDmc3KYcz1Rvlx;
	Mon, 18 Apr 2022 23:44:16 -0700 (PDT)
Message-ID: <7991758d-16b4-c9c4-0425-c2ec41943db8@opensource.wdc.com>
Date: Tue, 19 Apr 2022 15:44:15 +0900
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] Drop Documentation/ide/
Content-Language: en-US
To: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>
Cc: patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
 Jens Axboe <axboe@kernel.dk>, linux-ide@vger.kernel.org,
 linux-block@vger.kernel.org
References: <20220419011021.15527-1-rdunlap@infradead.org>
From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220419011021.15527-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/19/22 10:10, Randy Dunlap wrote:
> Drop all Documentation/ide/ since IDE support was deleted by
> Christoph Hellwig <hch@lst.de>, Jun 16 2021.
> 
> Fixes: b7fb14d3ac63 ("ide: remove the legacy ide driver")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: linux-ide@vger.kernel.org
> Cc: linux-block@vger.kernel.org

Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Jonathan,

Are you going to take this patch or do you want me to queue it through the
libata tree ?

-- 
Damien Le Moal
Western Digital Research
