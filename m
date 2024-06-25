Received: from wfhigh5-smtp.messagingengine.com (wfhigh5-smtp.messagingengine.com [64.147.123.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870D914A0B8
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 09:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308561; cv=none; b=ste3SoXw/BdcMzUz9dYiX4vlbmQt8SkS47kR6grxRS4NqpETH7JFwQAn1VSf2zrACug5at6Ks+4569kY7XvTuVhnaZUaKp9G5jNWBWv4XS/nvdWdMh3Fekl1HNnmjWHp7fLq2nZa79YAV8WhG84/81/JVeknRE3fFEgqOgklBUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308561; c=relaxed/simple;
	bh=pwz6bNvIdy2Q1ktYFHkD+WheTN1ZlYsJM3EZvIIL+WI=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=nGTJRxrwtaBhII5yFy5+MIrnoUYwJul9UaOfL4ngt+z6ZUpg3PuIXb1gYZ0InX8pf2GTILwmUwUJUg1E27KxAqeRFSyaXe7T7Qrz62NIf7wz2kDhb7N52WyCIGsQOXCloUi8J5sKBKtxERLf41N6x0ngMl50ZqG0HXAbOosiyyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ljones.dev; spf=none smtp.mailfrom=ljones.dev; dkim=pass (2048-bit key) header.d=ljones.dev header.i=@ljones.dev header.b=R7vXUPu2; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=JANvCCyM; arc=none smtp.client-ip=64.147.123.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ljones.dev
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ljones.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ljones.dev header.i=@ljones.dev header.b="R7vXUPu2";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="JANvCCyM"
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailfhigh.west.internal (Postfix) with ESMTP id 690E9180007C;
	Tue, 25 Jun 2024 05:42:38 -0400 (EDT)
Received: from imap41 ([10.202.2.91])
  by compute2.internal (MEProxy); Tue, 25 Jun 2024 05:42:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ljones.dev; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1719308558; x=1719394958; bh=N0hYYSV7fp
	YfGaMMAWqfey+TALMR8D2xS8PuNzsXDeM=; b=R7vXUPu2rWK53VcwNxq+TF/bt4
	E0l6EOqDtp5U1k06oDZIfyDdLZMiqmGfn7WmFphJKzrqxzvqsx1OEhZHVFf9SXv1
	AK1d5FTbEZKA+4d2x5DFv7Bs4RbEyADlP17Pz5KA63pBF2uaWQ/YFGLeATFLx+Ar
	eILXXm5Bqny1f5fU7pvKo7ba9iNfa1dlTKfKCJ3hnYa5YZ3m1HzNL6iCPlPNUDGE
	V94Xu3C8wTh4ursLgkfDoPrTs4QzwHIiMxUUnoZtD2MCzvoRrphNYD7ejUH91rxV
	qRPBKI/V2VYYmwkNTfxiAgVUmvJ8LKFwohqm4oxPjU1Mkkr1HpH3yKGqaebw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1719308558; x=1719394958; bh=N0hYYSV7fpYfGaMMAWqfey+TALMR
	8D2xS8PuNzsXDeM=; b=JANvCCyMBeTG35rQCImefFGDpuW7iug1wtypYCqY5iBD
	s3J+bUhzeW3JtzyHtBRzmkvfoy+AJRFxTDwfvgyXlNm9sTZQYVm4LqUN7jju7taC
	GjMQ/OyDGNeO4+HtzsMxKdke+t1D7AvcJPcUJF6+3ac61jdWqPjpEeAJX3ke2mAk
	s6LoLIDzJVyG4qNXJUCiQHrZkDESJEcatT4OQZ/VDDIRzrw6ad9nPxyusZGfFYu0
	LthskwvthcgL5GS6B/prV/HZ8hkLKk5LGf5cftd5854eRCJEwLRqfgqXB3Jhtw+x
	3alPjEypkX4wsJN56+NjWtPGOx5K9c8tQZ6kr+yQDA==
X-ME-Sender: <xms:DZF6Zv6i7G4xSe-4ioXBsOeCRxPVD-_2si0BVOJuhKbKqbBCcANLiw>
    <xme:DZF6Zk62T6MEGlFC9T7Pr7JYPa8W98AUy6pAA4ddkmQFwB2YAjxTt6oq_s7R9VJ_V
    TOOQBpa8nx5l3U4HB8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrfeegfedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedfnfhu
    khgvucflohhnvghsfdcuoehluhhkvgeslhhjohhnvghsrdguvghvqeenucggtffrrghtth
    gvrhhnpeelffevveffhfeuteetteevteelteduudfgjedvleejteetlefhieeiudfgveel
    feenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomheplhhukhgvsehljhhonhgvshdruggvvh
X-ME-Proxy: <xmx:DZF6ZmcLA9IOGtJVU7g6hIjnnPwSmSD2CVldlULoVEAfF8RoabD54A>
    <xmx:DZF6ZgLRYUEldKqKaoHhC1ToeFjZvizLqbaw5y547J2cqNGE740OzA>
    <xmx:DZF6ZjKOiV7Z8jWtt0Pk4c0f8oa-mS_osWLberOjTU5Q65Sg92ItpA>
    <xmx:DZF6ZpwTUcmKalNKwqDBrThxuEj7KmoABpcxyHNgXlydp3bU181E9A>
    <xmx:DpF6Zr3Q1e10DFSeKCvTYuFYJQSb58UGDbnZD3Aa6OoIVWec1aCQUrM6>
Feedback-ID: i5ec1447f:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id AEA762340080; Tue, 25 Jun 2024 05:42:37 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-538-g1508afaa2-fm-20240616.001-g1508afaa
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <532a1188-0429-4126-94cd-d77eccebd85d@app.fastmail.com>
In-Reply-To: <20240625085549.637011725@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
 <20240625085549.637011725@linuxfoundation.org>
Date: Tue, 25 Jun 2024 21:42:16 +1200
From: "Luke Jones" <luke@ljones.dev>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "Jiri Kosina" <jkosina@suse.com>,
 "Sasha Levin" <sashal@kernel.org>
Subject: Re: [PATCH 6.9 041/250] HID: asus: fix more n-key report descriptors if n-key
 quirked
Content-Type: text/plain

On Tue, 25 Jun 2024, at 9:29 PM, Greg Kroah-Hartman wrote:
> 6.9-stable review patch.  If anyone has any objections, please let me know.

Hi,

No objections here but I believe this patch must also be included if not already - https://lore.kernel.org/linux-input/20240528050555.1150628-1-andrewjballance@gmail.com/

Regards,
Luke.

> ------------------
> 
> From: Luke D. Jones <luke@ljones.dev>
> 
> [ Upstream commit 59d2f5b7392e988a391e6924e177c1a68d50223d ]
> 
> Adjusts the report descriptor for N-Key devices to
> make the output count 0x01 which completely avoids
> the need for a block of filtering.
> 
> Signed-off-by: Luke D. Jones <luke@ljones.dev>
> Signed-off-by: Jiri Kosina <jkosina@suse.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> drivers/hid/hid-asus.c | 51 ++++++++++++++++++++----------------------
> 1 file changed, 24 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
> index 78cdfb8b9a7ae..d6d8a028623a7 100644
> --- a/drivers/hid/hid-asus.c
> +++ b/drivers/hid/hid-asus.c
> @@ -335,36 +335,20 @@ static int asus_raw_event(struct hid_device *hdev,
> if (drvdata->quirks & QUIRK_MEDION_E1239T)
> return asus_e1239t_event(drvdata, data, size);
>  
> - if (drvdata->quirks & QUIRK_USE_KBD_BACKLIGHT) {
> + /*
> + * Skip these report ID, the device emits a continuous stream associated
> + * with the AURA mode it is in which looks like an 'echo'.
> + */
> + if (report->id == FEATURE_KBD_LED_REPORT_ID1 || report->id == FEATURE_KBD_LED_REPORT_ID2)
> + return -1;
> + if (drvdata->quirks & QUIRK_ROG_NKEY_KEYBOARD) {
> /*
> - * Skip these report ID, the device emits a continuous stream associated
> - * with the AURA mode it is in which looks like an 'echo'.
> + * G713 and G733 send these codes on some keypresses, depending on
> + * the key pressed it can trigger a shutdown event if not caught.
> */
> - if (report->id == FEATURE_KBD_LED_REPORT_ID1 ||
> - report->id == FEATURE_KBD_LED_REPORT_ID2) {
> + if (data[0] == 0x02 && data[1] == 0x30) {
> return -1;
> - /* Additional report filtering */
> - } else if (report->id == FEATURE_KBD_REPORT_ID) {
> - /*
> - * G14 and G15 send these codes on some keypresses with no
> - * discernable reason for doing so. We'll filter them out to avoid
> - * unmapped warning messages later.
> - */
> - if (data[1] == 0xea || data[1] == 0xec || data[1] == 0x02 ||
> - data[1] == 0x8a || data[1] == 0x9e) {
> - return -1;
> - }
> }
> - if (drvdata->quirks & QUIRK_ROG_NKEY_KEYBOARD) {
> - /*
> - * G713 and G733 send these codes on some keypresses, depending on
> - * the key pressed it can trigger a shutdown event if not caught.
> - */
> - if(data[0] == 0x02 && data[1] == 0x30) {
> - return -1;
> - }
> - }
> -
> }
>  
> if (drvdata->quirks & QUIRK_ROG_CLAYMORE_II_KEYBOARD) {
> @@ -1250,6 +1234,19 @@ static __u8 *asus_report_fixup(struct hid_device *hdev, __u8 *rdesc,
> rdesc[205] = 0x01;
> }
>  
> + /* match many more n-key devices */
> + if (drvdata->quirks & QUIRK_ROG_NKEY_KEYBOARD) {
> + for (int i = 0; i < *rsize + 1; i++) {
> + /* offset to the count from 0x5a report part always 14 */
> + if (rdesc[i] == 0x85 && rdesc[i + 1] == 0x5a &&
> +     rdesc[i + 14] == 0x95 && rdesc[i + 15] == 0x05) {
> + hid_info(hdev, "Fixing up Asus N-Key report descriptor\n");
> + rdesc[i + 15] = 0x01;
> + break;
> + }
> + }
> + }
> +
> return rdesc;
> }
>  
> @@ -1319,4 +1316,4 @@ static struct hid_driver asus_driver = {
> };
> module_hid_driver(asus_driver);
>  
> -MODULE_LICENSE("GPL");
> \ No newline at end of file
> +MODULE_LICENSE("GPL");
> -- 
> 2.43.0
> 
> 
> 
> 
