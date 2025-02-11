Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4EA26BD8C;
	Tue, 11 Feb 2025 15:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739286344; cv=none; b=GniZyXWWavC9u2KWn3A0UYP28C2++q1EBlRRlLdhPfKAGXAvl0mynjzy/ePMtvfL2qgGqQCHZAboVHHlbUiF4XQNuzaII3qi4kZibovmf4tKOo8Kns1SLT2FI8eH36oXmeyYr4PQpm1zUEZEqLY1AhMYSbGoB7azquOWvdcZYzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739286344; c=relaxed/simple;
	bh=pK7wwx9SVBb/t9cDWPPmU/QNvvDUShUMo8z50n5diB0=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=kG+5p9YqWZXIjX3/ceSgcWYK+O/E1nS2OC5D6sAeJqldPMpE2wCCVg6JDDee3PbDtXqVoCUQvD9YxM9U7KWHaBrqTJK7HzM1RgtkI1a0q6nMf25lvwhWqqWhAr++FS8LrltcdsZ7EPV7PspsBi9FYw6zzMYwWpWGyNBHyOc4HRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=squebb.ca; spf=pass smtp.mailfrom=squebb.ca; dkim=pass (2048-bit key) header.d=squebb.ca header.i=@squebb.ca header.b=UZXfgyE/; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=DXx9IwbI; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=squebb.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=squebb.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=squebb.ca header.i=@squebb.ca header.b="UZXfgyE/";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="DXx9IwbI"
Received: from phl-compute-02.internal (phl-compute-02.phl.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 53CFB1140123;
	Tue, 11 Feb 2025 10:05:39 -0500 (EST)
Received: from phl-imap-10 ([10.202.2.85])
  by phl-compute-02.internal (MEProxy); Tue, 11 Feb 2025 10:05:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=squebb.ca; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1739286339;
	 x=1739372739; bh=/N1ern3xpY1CU833/SifUcUn0BSm+HC+YjRriOA6Ues=; b=
	UZXfgyE/b53ktvnjWEHDqkkw1zLCJem+7GweMm7e3FJR+8/SjRC/wrZGMgP8M8RA
	OpuGgZbuCn9Yb28i04Deu5/ptmcOm2saFlWbz419t7+/Ml2ZfD5phIYGRgfb2EAX
	Ct3vvxYPiUfxu2gYWs0AT3f8EVqWuv/3WOrn2bTy28ufGI/xcDKS6s92oxJEglSV
	sm3z53k2gxbaryclP4y13PqWHpGCNMYPCtMJQtw9PcStL7QQHiznaZW3qvFrV89q
	1lsiDnmaEocuQYydHqaxO57Ca8NLPj0R+SDsVkQ9PWiILvNx9rYNhcXGkJ/cjebS
	pquAFf3aSm9tD8fMxoTMyg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1739286339; x=
	1739372739; bh=/N1ern3xpY1CU833/SifUcUn0BSm+HC+YjRriOA6Ues=; b=D
	Xx9IwbIfcAE+PEez40DVt9OBrR1sIh35PUVkv/gP3hlxPrsI5Zvy41zpT0WA4qlv
	h9xebjZ9dvqhjmTemSxvdles5Koi96sNFjHDI1YJjgjokK7vjyLDIefJ1LXPqKC8
	82oaKXCDbJJPJvjmLx92PcOYWgGyt65ogybrPIqubZD30xsa6cF5zWBJUNvc0AL/
	6aWfnyBE0yedI3TWM4YquuAqehZ3SOWpuO1iMSB1CjPtd65Nw9hqsjM1tQeUORt5
	P+yMcx+pOXyXGFbqGDPOrLHP79gZdaKq3g6jH19yk277NtV7UsKPzxojmt9DRkX0
	F98w5ocMAqb9Ci7cI4T9w==
X-ME-Sender: <xms:QmerZz8VhyhyZs0O1TuJfffSfk-LsreYXnTRgTGMWZosIBsuaUNgKg>
    <xme:QmerZ_vBpB4Z00NkBWTP52p58NmHB_qzDlVnqYhgt8ZaJcNsPL07XGlCjGYPO1rwD
    K-AwfeiE5B3qg9Vfb8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgdegudefudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthejredtredt
    tdenucfhrhhomhepfdforghrkhcurfgvrghrshhonhdfuceomhhpvggrrhhsohhnqdhlvg
    hnohhvohesshhquhgvsggsrdgtrgeqnecuggftrfgrthhtvghrnhepleevvdeihfffgeel
    ieeugedtiefggeelledtheektdduudeggeefheeuleduvdehnecuffhomhgrihhnpehgih
    hthhhusgdrtghomhdpkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomhepmhhpvggrrhhsohhnqdhlvghnohhvohesshhquh
    gvsggsrdgtrgdpnhgspghrtghpthhtohepudefpdhmohguvgepshhmthhpohhuthdprhgt
    phhtthhopehmrghrihhordhlihhmohhntghivghllhhosegrmhgurdgtohhmpdhrtghpth
    htohepshgrmhhithholhhvrghnvghnsehgohhoghhlvgdrtghomhdprhgtphhtthhopehl
    khhmlhesjhhohhhnrhhofihlvgihrdhmvgdprhgtphhtthhopehkvggvsheskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtoheplhgvnhgssehkvghrnhgvlhdrohhrghdprhgtphhtthho
    pehnrghthhgrnheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprhgrfhgrvghlsehkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopehllhhvmheslhhishhtshdrlhhinhhugidruggv
    vhdprhgtphhtthhopehprghttghhvghssehlihhsthhsrdhlihhnuhigrdguvghv
X-ME-Proxy: <xmx:QmerZxByMocufgxC9mxPdt4-2R6pJI7B9xNKg-z7QEQKMq-X3BOwTg>
    <xmx:QmerZ_dcmC4GS78T0KJfXIX-Mu08pnVv8m809fRH7p52A_cUenoikw>
    <xmx:QmerZ4NDXdxsfQGWmXFluPguDiq7P_QyItILiD1THkrLlGeIEA7LZQ>
    <xmx:QmerZxkNCPbV7l0wWEV3zp943RmBecRqGWAfVs7XgsdW1khtUFyJ2w>
    <xmx:Q2erZ0m8IDWnvUs4Mpbnfjqjbxj2k-cyaAX1aMlnslynh1WhkD418kf8>
Feedback-ID: ibe194615:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id BF18A3C0069; Tue, 11 Feb 2025 10:05:38 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Tue, 11 Feb 2025 10:05:18 -0500
From: "Mark Pearson" <mpearson-lenovo@squebb.ca>
To: "Nathan Chancellor" <nathan@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, "Len Brown" <lenb@kernel.org>
Cc: "Hans de Goede" <hdegoede@redhat.com>,
 "Limonciello, Mario" <mario.limonciello@amd.com>,
 "Kees Cook" <kees@kernel.org>, "Sami Tolvanen" <samitolvanen@google.com>,
 "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev,
 stable@vger.kernel.org, "John Rowley" <lkml@johnrowley.me>
Message-Id: <52c49252-7a81-4d27-a8a9-b2f1e5f837df@app.fastmail.com>
In-Reply-To: 
 <20250210-acpi-platform_profile-fix-cfi-violation-v3-1-ed9e9901c33a@kernel.org>
References: 
 <20250210-acpi-platform_profile-fix-cfi-violation-v3-1-ed9e9901c33a@kernel.org>
Subject: Re: [PATCH v3] ACPI: platform-profile: Fix CFI violation when accessing sysfs
 files
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Nathan

On Mon, Feb 10, 2025, at 9:28 PM, Nathan Chancellor wrote:
> When an attribute group is created with sysfs_create_group(), the
> ->sysfs_ops() callback is set to kobj_sysfs_ops, which sets the ->show()
> and ->store() callbacks to kobj_attr_show() and kobj_attr_store()
> respectively. These functions use container_of() to get the respective
> callback from the passed attribute, meaning that these callbacks need to
> be the same type as the callbacks in 'struct kobj_attribute'.
>
> However, the platform_profile sysfs functions have the type of the
> ->show() and ->store() callbacks in 'struct device_attribute', which
> results a CFI violation when accessing platform_profile or
> platform_profile_choices under /sys/firmware/acpi because the types do
> not match:
>
>   CFI failure at kobj_attr_show+0x19/0x30 (target: 
> platform_profile_choices_show+0x0/0x140; expected type: 0x7a69590c)
>
> There is no functional issue from the type mismatch because the layout
> of 'struct kobj_attribute' and 'struct device_attribute' are the same,
> so the container_of() cast does not break anything aside from CFI.
>
> Change the type of platform_profile_choices_show() and
> platform_profile_{show,store}() to match the callbacks in
> 'struct kobj_attribute' and update the attribute variables to match,
> which resolves the CFI violation.
>
> Cc: stable@vger.kernel.org
> Fixes: a2ff95e018f1 ("ACPI: platform: Add platform profile support")
> Reported-by: John Rowley <lkml@johnrowley.me>
> Closes: https://github.com/ClangBuiltLinux/linux/issues/2047
> Tested-by: John Rowley <lkml@johnrowley.me>
> Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> Changes in v3:
> - Rebase on 6.14-rc1, which includes updates to the driver to address
>   Greg's previous concerns but this change is still needed for the
>   legacy sysfs interface. v2 can be used for the stable backport.
> - Link to v2: 
> https://lore.kernel.org/r/20241118-acpi-platform_profile-fix-cfi-violation-v2-1-62ff952804de@kernel.org
>
> Changes in v2:
> - Rebase on linux-pm/acpi
> - Pick up Sami's reviewed-by tag
> - Adjust wording around why there is no functional issue from the
>   mismatched types
> - Link to v1: 
> https://lore.kernel.org/r/20240819-acpi-platform_profile-fix-cfi-violation-v1-1-479365d848f6@kernel.org
> ---
>  drivers/acpi/platform_profile.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/acpi/platform_profile.c 
> b/drivers/acpi/platform_profile.c
> index fc92e43d0fe9..1b6317f759f9 100644
> --- a/drivers/acpi/platform_profile.c
> +++ b/drivers/acpi/platform_profile.c
> @@ -260,14 +260,14 @@ static int _aggregate_choices(struct device *dev, 
> void *data)
> 
>  /**
>   * platform_profile_choices_show - Show the available profile choices 
> for legacy sysfs interface
> - * @dev: The device
> + * @kobj: The kobject
>   * @attr: The attribute
>   * @buf: The buffer to write to
>   *
>   * Return: The number of bytes written
>   */
> -static ssize_t platform_profile_choices_show(struct device *dev,
> -					     struct device_attribute *attr,
> +static ssize_t platform_profile_choices_show(struct kobject *kobj,
> +					     struct kobj_attribute *attr,
>  					     char *buf)
>  {
>  	unsigned long aggregate[BITS_TO_LONGS(PLATFORM_PROFILE_LAST)];
> @@ -333,14 +333,14 @@ static int _store_and_notify(struct device *dev, 
> void *data)
> 
>  /**
>   * platform_profile_show - Show the current profile for legacy sysfs interface
> - * @dev: The device
> + * @kobj: The kobject
>   * @attr: The attribute
>   * @buf: The buffer to write to
>   *
>   * Return: The number of bytes written
>   */
> -static ssize_t platform_profile_show(struct device *dev,
> -				     struct device_attribute *attr,
> +static ssize_t platform_profile_show(struct kobject *kobj,
> +				     struct kobj_attribute *attr,
>  				     char *buf)
>  {
>  	enum platform_profile_option profile = PLATFORM_PROFILE_LAST;
> @@ -362,15 +362,15 @@ static ssize_t platform_profile_show(struct device *dev,
> 
>  /**
>   * platform_profile_store - Set the profile for legacy sysfs interface
> - * @dev: The device
> + * @kobj: The kobject
>   * @attr: The attribute
>   * @buf: The buffer to read from
>   * @count: The number of bytes to read
>   *
>   * Return: The number of bytes read
>   */
> -static ssize_t platform_profile_store(struct device *dev,
> -				      struct device_attribute *attr,
> +static ssize_t platform_profile_store(struct kobject *kobj,
> +				      struct kobj_attribute *attr,
>  				      const char *buf, size_t count)
>  {
>  	unsigned long choices[BITS_TO_LONGS(PLATFORM_PROFILE_LAST)];
> @@ -401,12 +401,12 @@ static ssize_t platform_profile_store(struct device *dev,
>  	return count;
>  }
> 
> -static DEVICE_ATTR_RO(platform_profile_choices);
> -static DEVICE_ATTR_RW(platform_profile);
> +static struct kobj_attribute attr_platform_profile_choices = 
> __ATTR_RO(platform_profile_choices);
> +static struct kobj_attribute attr_platform_profile = 
> __ATTR_RW(platform_profile);
> 
>  static struct attribute *platform_profile_attrs[] = {
> -	&dev_attr_platform_profile_choices.attr,
> -	&dev_attr_platform_profile.attr,
> +	&attr_platform_profile_choices.attr,
> +	&attr_platform_profile.attr,
>  	NULL
>  };
> 
>
> ---
> base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
> change-id: 20240819-acpi-platform_profile-fix-cfi-violation-de278753bd5f
>
> Best regards,
> -- 
> Nathan Chancellor <nathan@kernel.org>

Just a note to say thank you for noticing my email address change - the old lenovo one was awful to use so I dropped it a while back, but it meant I missed your first two patches (my mail filters for the list should have caught it and I'll have to figure out why not...)

From the V1 patch there was a question about why it was done this way: I believe I just copied how it seems to be done everywhere else in the kernel. I can't remember what I used as a reference exactly, but I went and checked a few random drivers and it seems to be everywhere.

Patch looks fine (I'd like to try it out on my system - will aim to do that today). I didn't know what CFI was (and have lightly educated myself now). 
Is there a better way to fix this so it's common across all drivers somehow? Updating every individual instance is going to be a lot.

Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>

Mark
