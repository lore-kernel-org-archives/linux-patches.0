Received: from fhigh8-smtp.messagingengine.com (fhigh8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12391836F3;
	Thu, 18 Apr 2024 19:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713469601; cv=none; b=BifySO6mt7kM2I+WrjEjpOt+javDK/pIGYg/37a8s9bhQVXfLdw8Hgfe0jRQLGvguJe1C2nwlGVavYS8eBcXo0BO6Q4mCKTY1OIGtIiRPppr7zMQoh3NIFcoOj7qwOTBBTsorFPi4nczm2TuIQXo2Ktecb81dbVOYYxW4Ri3yXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713469601; c=relaxed/simple;
	bh=+3RotaxHzSvnFAl/H53BNr33qFv3TxvR2u6MwgIaq/Q=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=BzzLqYlr+jMo7shvULlJ8z8JemGCn9IuoklVlE5BVrzOi0oXSAG6OwsMbtQhxw6GRtqqgkn+TXsw6kIetfGR37vLqNRmMsw/9scsQ3Bxx6ESZwLSMpwl9W0oVLH6/oqCY55o7Bjd2MG7ZFGvwsHNaQqQbEAdpnOXbCvrQksY0nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=rwwFZ/0K; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=GO0+OuHI; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="rwwFZ/0K";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="GO0+OuHI"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id CDECB114015A;
	Thu, 18 Apr 2024 15:46:38 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Thu, 18 Apr 2024 15:46:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1713469598; x=1713555998; bh=UV2QZ0oKQS
	+W1d7GsHZtbm3RtPzbf1oADrPa/J1FbDM=; b=rwwFZ/0KA4ikU9LTnRnEkLX62k
	w6B2PlCg/yLgoTZsAKr31B3xQczqBgwqjtBgdgoFz99wySQ/6RryftGJWDOMVHbQ
	k/u0mkVFFC7Dc3IE3uldtgZtRsUJDi+9GZwh4s+2bpJOqzk1d46cQERsqIqAk4xC
	yjkp689FKoX6CL7FGTyJwn+i00vtoNVeE96oBZoR+FC4vWZvITbQaELhGkallTXH
	wCetx/ntF4uHJB/kMfApt9RIrMwdlyAKc7eLl6f9ZyZHGste7Ouwwqh7/4xIF0LG
	ZuKG1IRM5a9bq4tC16F+TZKhYYSmXBo3/c5nLWjFAdgwhI+B3o/t1LZLyDeg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1713469598; x=1713555998; bh=UV2QZ0oKQS+W1d7GsHZtbm3RtPzb
	f1oADrPa/J1FbDM=; b=GO0+OuHIogwk+wCCTkoM/YzzMgR0h+DTgFkxaJHoeB/c
	8rAxMBe6t5y4EqiFDZ8iko6vQbT95Pccf59VjllS3Skq4pVCCbJTd+DTd9m8cq4I
	iko7Q9RFLa3NnjdcCf4y3EPxk5iaHi04iSZ5c0H3W+JokWbxxgruojrbFtdMP8uZ
	iV8f8bkg6ABUkcYTDuj5XwMFyAQZFLYkaCLkaOsLrPpfpAh6/rKAhKTQ8R1EPqd7
	aDTuU6qN20q9K2TUIQImddPkyQlIPnlJcz7Qc9FuGMfWeQvgiwKtIwWED5wALvMj
	CeDgADvnct1K+iO+0VkhhoQPP7AM0pNRSbRmHb17yA==
X-ME-Sender: <xms:nnghZmkoua8JzlS38HcKMwKAztZRzf1zpUDbMSavHB91BYGFu2GoBg>
    <xme:nnghZt2m5sL5UIYqleAyCRfHK8qm4WZ0Xyf5z_Ddc3z16c4Dz9yU05YD-nBXAa6QS
    bkIHj1E2cbrtRIdYBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrudektddgudegtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeevhfffledtgeehfeffhfdtgedvheejtdfgkeeuvefgudffteettdekkeeu
    feehudenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:nnghZkryO6dKn-ODM8I4SzRCMBEHO7sJEAVaa8j4qsYxYEZal-2BFQ>
    <xmx:nnghZqkRUN1fa93XBtvh_yIp7DSW3b3E3xt32Ce09NNlB-HVtROaww>
    <xmx:nnghZk0fBT28SOY_NzfOl7WEijLjUVqrun7e9YVku8tEsrw8SX9TTw>
    <xmx:nnghZhseMLfKm9UyvwM2EqF5NNIOwuYvxpQCtOhSbAK0fj5MGy7sMg>
    <xmx:nnghZqPw7TxCIUoofzl4cDqlF_5T5dmBFsnxnSKBp4lAU3QTbJTPmi6d>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 5D8C1B6008D; Thu, 18 Apr 2024 15:46:38 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-379-gabd37849b7-fm-20240408.001-gabd37849
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <798df2d7-b13f-482a-8d4a-106c6492af01@app.fastmail.com>
In-Reply-To: <20240418151501.6056-C-hca@linux.ibm.com>
References: 
 <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
 <20240417-s390-drivers-fix-cast-function-type-v1-1-fd048c9903b0@kernel.org>
 <20240418095438.6056-A-hca@linux.ibm.com>
 <20240418102549.6056-B-hca@linux.ibm.com>
 <20240418145121.GA1435416@dev-arch.thelio-3990X>
 <20240418151501.6056-C-hca@linux.ibm.com>
Date: Thu, 18 Apr 2024 21:46:18 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Heiko Carstens" <hca@linux.ibm.com>,
 "Nathan Chancellor" <nathan@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, gor@linux.ibm.com,
 "Alexander Gordeev" <agordeev@linux.ibm.com>,
 "Christian Borntraeger" <borntraeger@linux.ibm.com>,
 "Sven Schnelle" <svens@linux.ibm.com>, wintera@linux.ibm.com,
 twinkler@linux.ibm.com, linux-s390@vger.kernel.org,
 Netdev <netdev@vger.kernel.org>, llvm@lists.linux.dev,
 patches@lists.linux.dev
Subject: Re: [PATCH 1/3] s390/vmlogrdr: Remove function pointer cast
Content-Type: text/plain

On Thu, Apr 18, 2024, at 17:15, Heiko Carstens wrote:
>> > > > -		/*
>> > > > -		 * The release function could be called after the
>> > > > -		 * module has been unloaded. It's _only_ task is to
>> > > > -		 * free the struct. Therefore, we specify kfree()
>> > > > -		 * directly here. (Probably a little bit obfuscating
>> > > > -		 * but legitime ...).
>> > > > -		 */
>> > > 
>> > > Why is the comment not relevant after this change? Or better: why is it not
>> > > valid before this change, which is why the code was introduced a very long
>> > > time ago? Any reference?
>> > > 
>> > > I've seen the warning since quite some time, but didn't change the code
>> > > before sure that this doesn't introduce the bug described in the comment.
>> > 
>> > From only 20 years ago:
>> > 
>> > https://lore.kernel.org/all/20040316170812.GA14971@kroah.com/
>> > 
>> > The particular code (zfcp) was changed, so it doesn't have this code
>> > (or never did?)  anymore, but for the rest this may or may not still
>> > be valid.
>> 
>> I guess relevant may not have been the correct word. Maybe obvious? I
>> can keep the comment but I do not really see what it adds, although
>> reading the above thread, I suppose it was added as justification for
>> calling kfree() as ->release() for a 'struct device'? Kind of seems like
>> that ship has sailed since I see this all over the place as a
>> ->release() function. I do not see how this patch could have a function
>> change beyond that but I may be misreading or misinterpreting your full
>> comment.
>
> That doesn't answer my question what prevents the release function
> from being called after the module has been unloaded.
>
> At least back then when the code was added it was a real bug.

I think the way this should work is to have the allocation and
the release function in the iucv bus driver, with a function
roughly like

struct device *iucv_alloc_device(char *name,
               const struct attribute_group *attrs,
               void *priv)
{
      dev = kzalloc(sizeof(struct device), GFP_KERNEL);
      if (!dev)
           return NULL;

      dev_set_name(dev, "%s", name);
      dev->bus = &iucv_bus;
      dev->parent = iucv_root;
      dev->groups = attrs;
      dev_set_drvdata(dev, priv);
      dev->release = iucv_free_dev;
  
      return dev;
}

Now the release function cannot go away as long as any module
is loaded that links against it, and those modules cannot
go away as long as the devices are in use.

I don't remember how iucv works, but if there is a way to
detect which system services exist, then the actual device
creation should also be separate from the driver using those
services, with another driver responsible for enumerating
the existing services and creating those devices.

      Arnd
