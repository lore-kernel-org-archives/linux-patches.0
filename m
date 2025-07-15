Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F357B672;
	Tue, 15 Jul 2025 19:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752609298; cv=none; b=dcG12RVFzVArB/FnK/Bl8SUfY23tbO3p2nsevu0JKx5cOBdUiRjwT7J7kMVGUC9RB0MEMG/HZA6RR4G6FX03HM+Q6INL+XNBN/l+BLyOpKo77iD35Dm2fDY4NZgF0l9vXnM60IM7v2BoF9sUinvww2/Png97YWt2x+CbLUTL+W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752609298; c=relaxed/simple;
	bh=QRZp+4I8maMQPrmjNoRyUwwSYnT+bKiX3aX0Y433DVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ACroH+nZYqURNkESZV6wntvwqc77nrehRJl7DYH9i9TQhzYDK/YN7TZvexWDYfry3VD1tS+cmAm4Cei2ErfLDU9Oayqgd0SNaMmp+y00QXiZot+nSQ/Ezq7zaeikTQVZzhaEliE8X1W3B/9BlcScSN5jU0BuvHjWP5d9exqtZ0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rdodJGVK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rdodJGVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8BCC4CEE3;
	Tue, 15 Jul 2025 19:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752609298;
	bh=QRZp+4I8maMQPrmjNoRyUwwSYnT+bKiX3aX0Y433DVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rdodJGVK4uo4adZp/P3a8MMJi67HL9sr270p92nS9sHZLLEaH2+WesXl7ZBUTGsXo
	 zB3IFq62diBa7eefr9dVtCybrbSq2VCRA0O6EuJILOPWtQiokuPGRhH0ZngMQXM17Z
	 23LQ05CvXYGkdBWuxHV4kVZdrTFiKfDPbiOGpu7Dzf4xdt7dNyRxaUmFbYUJag7htQ
	 1nfuFFSmUaglJsi7So1gUYSiGsSnzL4nHNjx6LJcNwDY9GA316H9rmhxTND1HQgGgX
	 1SixH2X7GlVGAW0J4meIznLjmjEKUi6WSZrTkRp6eaMKmZXZCs9C2SqRXGQcZk8GgG
	 L5c0MhCdR4m3g==
Date: Tue, 15 Jul 2025 15:12:52 -0400
From: Sasha Levin <sashal@kernel.org>
To: Kurt Borja <kuurtb@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Mark Pearson <mpearson-lenovo@squebb.ca>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: Re: [PATCH 5.15 53/77] platform/x86: think-lmi: Fix sysfs group
 cleanup
Message-ID: <aHaoNDFKsoogzNge@lappy>
References: <20250715130751.668489382@linuxfoundation.org>
 <20250715130753.855799519@linuxfoundation.org>
 <DBCUJ1QHGTKA.3H4TW1FB3FYJC@gmail.com>
 <aHamVeuNznVqMb2x@lappy>
 <DBCVGAAFB8Q3.21ZP9FUITWDI9@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DBCVGAAFB8Q3.21ZP9FUITWDI9@gmail.com>

On Tue, Jul 15, 2025 at 04:22:22PM -0300, Kurt Borja wrote:
>Hi Sasha,
>
>On Tue Jul 15, 2025 at 4:04 PM -03, Sasha Levin wrote:
>> On Tue, Jul 15, 2025 at 03:38:58PM -0300, Kurt Borja wrote:
>>>Hi Greg,
>>>
>>>On Tue Jul 15, 2025 at 10:13 AM -03, Greg Kroah-Hartman wrote:
>>>> 5.15-stable review patch.  If anyone has any objections, please let me know.
>>>>
>>>> ------------------
>>>>
>>>> From: Kurt Borja <kuurtb@gmail.com>
>>>>
>>>> [ Upstream commit 4f30f946f27b7f044cf8f3f1f353dee1dcd3517a ]
>>>>
>>>> Many error paths in tlmi_sysfs_init() lead to sysfs groups being removed
>>>> when they were not even created.
>>>>
>>>> Fix this by letting the kobject core manage these groups through their
>>>> kobj_type's defult_groups.
>>>>
>>>> Fixes: a40cd7ef22fb ("platform/x86: think-lmi: Add WMI interface support on Lenovo platforms")
>>>> Cc: stable@vger.kernel.org
>>>> Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
>>>> Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
>>>> Signed-off-by: Kurt Borja <kuurtb@gmail.com>
>>>> Link: https://lore.kernel.org/r/20250630-lmi-fix-v3-3-ce4f81c9c481@gmail.com
>>>> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
>>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>>> ---
>>>>  drivers/platform/x86/think-lmi.c | 35 +++++++++-----------------------
>>>>  1 file changed, 10 insertions(+), 25 deletions(-)
>>>>
>>>> diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
>>>> index 36ff64a7b6847..cc46aa5f1da2c 100644
>>>> --- a/drivers/platform/x86/think-lmi.c
>>>> +++ b/drivers/platform/x86/think-lmi.c
>>>> @@ -491,6 +491,7 @@ static struct attribute *auth_attrs[] = {
>>>>  static const struct attribute_group auth_attr_group = {
>>>>  	.attrs = auth_attrs,
>>>>  };
>>>> +__ATTRIBUTE_GROUPS(auth_attr);
>>>>
>>>>  /* ---- Attributes sysfs --------------------------------------------------------- */
>>>>  static ssize_t display_name_show(struct kobject *kobj, struct kobj_attribute *attr,
>>>> @@ -643,6 +644,7 @@ static const struct attribute_group tlmi_attr_group = {
>>>>  	.is_visible = attr_is_visible,
>>>>  	.attrs = tlmi_attrs,
>>>>  };
>>>> +__ATTRIBUTE_GROUPS(tlmi_attr);
>>>>
>>>>  static ssize_t tlmi_attr_show(struct kobject *kobj, struct attribute *attr,
>>>>  				    char *buf)
>>>> @@ -688,12 +690,14 @@ static void tlmi_pwd_setting_release(struct kobject *kobj)
>>>>
>>>>  static struct kobj_type tlmi_attr_setting_ktype = {
>>>>  	.release        = &tlmi_attr_setting_release,
>>>> -	.sysfs_ops	= &tlmi_kobj_sysfs_ops,
>>>> +	.sysfs_ops	= &kobj_sysfs_ops,
>>>> +	.default_groups = tlmi_attr_groups,
>>>
>>>I did *not* author this change and it utterly *breaks* the driver.
>>>
>>>This patch should be dropped ASAP.
>>
>> Right sorry about that - I accidently left that extra line of context
>> you've pointed out. Dropped now along with the other patch you've
>> pointed out.
>
>Thank you for the quick response!
>
>May I suggest informing authors and maintainers about manual conflict
>resolution in the email's subject?
>
>This resolution was not acked by anyone and I don't appreciate that.

In general we'd note a manual resolution and wait for an ack if any
significant changes were made to a commit.

In this case I messed up the context when resolving the conflict, and
didn't consider it meaningful.

However, yes, just noting that along with my signoff wouldn't have hurt.
I'll start doing that more often.

>In the past couple of weeks and I got like 50 stable related emails. I
>simply cannot check each and every one for things like this.

Is there something we can do on our end to make it more managable?

-- 
Thanks,
Sasha
