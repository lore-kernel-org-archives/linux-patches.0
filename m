Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A422C9D
	for <patches@lists.linux.dev>; Mon, 31 Jan 2022 11:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A97C340F0;
	Mon, 31 Jan 2022 11:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1643628897;
	bh=2407Vuhcto4kD119wVw/S2J1BcsizFF4juBzYKHE9Sg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wXbYWDO3Ry1Xiy0Fd/uo4V0ovRRG164IaCjllIIFRZ4V0otG8kRVtXT3wBHd75glv
	 xRA96Tb3MsGuDQimrSOFfq3pVyQBjqNOli38AQqkZvzYsb8C37WHK0Em0QJ6/7DmaX
	 UgVliPm0UJJ3c8uJ3Dq5v8BQNWVcKQ8H/dYqNJ+U=
Date: Mon, 31 Jan 2022 12:34:54 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Smita Koralahalli Channabasappa <smita.koralahallichannabasappa@amd.com>,
	Wei Huang <wei.huang2@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, patches@lists.linux.dev
Subject: Re: [PATCH v2 5/6] topology/sysfs: Add format parameter to macro
 defining "show" functions for proc
Message-ID: <YffJXqWYbflp3Wm2@kroah.com>
References: <20220107225442.1690165-1-tony.luck@intel.com>
 <20220121174743.1875294-1-tony.luck@intel.com>
 <20220121174743.1875294-6-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121174743.1875294-6-tony.luck@intel.com>

On Fri, Jan 21, 2022 at 09:47:42AM -0800, Tony Luck wrote:
> All the simple (non-mask and non-list files in
> /sys/devices/system/cpu/cpu0/topology/ are currently printed as decimal
> integers.
> 
> Refactor the macro that generates the "show" functions to take a format
> parameter to allow future files to display in other formats.
> 
> No functional change.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  drivers/base/topology.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
