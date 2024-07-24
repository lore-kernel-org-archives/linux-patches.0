Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230342D030;
	Wed, 24 Jul 2024 13:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721828899; cv=none; b=EpLcy5Gslj+UgIJw7rOTcU0lGt7HHvp4VCN3eTYWtycWsMKN4tlhUkMD/xggspoEnGdi/4ZPHRzZsBJQfq1lZTffB1O5jujzkanUio3XvALV7UYgfyspfX0sqVAz8YMNyfPSrYRUCqOdvcu3sZ1l4xoAk47nigG5CRfpqZQdMrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721828899; c=relaxed/simple;
	bh=ps9Nex5mSgecEMZtQBYYX1ukXbzSj6jTlK3awGbyE50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=psshI9mAAXEKEa+1lR+WP89DJTdhrHIpOpCyVqoSqLk4ZHsbfxlG8ekmtMqwM25k5QpvyAGUInS3s2tYalapMnFAXj8AD9/nCxX33UnArtJ6KBRuXuy/9RBlD5Ry1leYYYLkRrcrwVOoj93IA1jJW3u2bke6+1KvSBjXfQA1QFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnrmU6sR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnrmU6sR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0FCC32781;
	Wed, 24 Jul 2024 13:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721828898;
	bh=ps9Nex5mSgecEMZtQBYYX1ukXbzSj6jTlK3awGbyE50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pnrmU6sRY7Y+6ZvRBwmC8++1urEhrudckFH/VE8YbFnZ9r6jpJUYynPl8v4tHeVJx
	 6v6obIycT5ZvXcJFnT1lijsNF+3O+EjFpLAooB+j6M5NwrIy5qoYXMteiQP7PNjbjF
	 MtJo08MAdOrJTYQXUPmkHU6al/uZ4mo9JE3/i70k=
Date: Wed, 24 Jul 2024 15:48:15 +0200
From: 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>
To: Simon Trimmer <simont@opensource.cirrus.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	'Takashi Iwai' <tiwai@suse.de>, 'Sasha Levin' <sashal@kernel.org>
Subject: Re: [PATCH 6.6 061/129] ALSA: hda: cs35l56: Select
 SERIAL_MULTI_INSTANTIATE
Message-ID: <2024072402-hesitant-rural-ca4a@gregkh>
References: <20240723180404.759900207@linuxfoundation.org>
 <20240723180407.143962331@linuxfoundation.org>
 <000201daddad$047f1910$0d7d4b30$@opensource.cirrus.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000201daddad$047f1910$0d7d4b30$@opensource.cirrus.com>

On Wed, Jul 24, 2024 at 10:36:53AM +0100, Simon Trimmer wrote:
> > -----Original Message-----
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: Tuesday, July 23, 2024 7:23 PM
> > To: stable@vger.kernel.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
> > patches@lists.linux.dev; Simon Trimmer <simont@opensource.cirrus.com>;
> > Takashi Iwai <tiwai@suse.de>; Sasha Levin <sashal@kernel.org>
> > Subject: [PATCH 6.6 061/129] ALSA: hda: cs35l56: Select
> > SERIAL_MULTI_INSTANTIATE
> > 
> > 6.6-stable review patch.  If anyone has any objections, please let me
> know.
> 
> Hi Greg,
> (As remarked on 6.9-stable) Takashi made a corrective patch to this one as
> there were some build problems -
> https://lore.kernel.org/all/20240621073915.19576-1-tiwai@suse.de/

And that commit should be in here already.

thanks,

greg k-h
