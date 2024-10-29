Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F081DED5A;
	Tue, 29 Oct 2024 11:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730201219; cv=none; b=oPY+PJDwWE9YZz+n4JpWUMKny6PxIkexqJrwg2fifkYxt3aZml1YTDcCrjimON9FLH6ZihnMV4jvffjE2kuRpelOxBW7CuS+92fdQ0KyfTUmHXj8vo1yGRpiZ9jacUTaMWOo2PydVRagHVHN+FUKEkG0xcynpIlaiLYWq3/ZP/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730201219; c=relaxed/simple;
	bh=beV/g5Igfw8MxzaDPPmH0oLvRyMYH23d/Tpi2UmKCHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c38OlJyr8YR+4+n12GVGOj45vf9sGzTWwi2PKvqGKw9OZDK2/2KoAqupfGi8RfRy/cNNqnnT8c2zEovBzJwfz2Bg8mAAAI5I8cgWOuVKL/MHWg1iu8o9SVlRU3VJen5GuXJOD/F/K+c1sIokBol/Oc0a2mdJXWYR9uaJxont0yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dbyeC4Xi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dbyeC4Xi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DEFC4CEE3;
	Tue, 29 Oct 2024 11:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730201218;
	bh=beV/g5Igfw8MxzaDPPmH0oLvRyMYH23d/Tpi2UmKCHo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dbyeC4XiZjhsJsPt3TOHoZT1UldIUMN5ZCVG9iohE/I94xiHAxJ1Zwekq6xkAeM/H
	 E4GiKxgLR9ZrSanKT/ih9V8akyzNWukaqqqqBB3vrlhtWUW0uNYB3YhuD/mpYFxmzr
	 /YX6BsiV7/96WEW7zPPzkn/nOhAml+2ASRMIxi+PbQydYf6IMoj2+Sz2pUuWicuQ6s
	 nzhoBVnWGNcGCKbb/D99mhMjtUhNsLeZjzglMLPJirC06VDIJc1AdOLtm1XbpKh5Nd
	 hL86zNRF4oQItQbgOfaEErk0f1MoOgwlU2Yq+bHcuaPKhYWfR1st4Wo7UaW8/HH9Qt
	 d43v8yvMVfL4Q==
Date: Tue, 29 Oct 2024 07:26:56 -0400
From: Sasha Levin <sashal@kernel.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Rodolfo Giometti <giometti@enneenne.com>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: Re: [PATCH 6.1 068/137] tty/serial: Make
 ->dcd_change()+uart_handle_dcd_change() status bool active
Message-ID: <ZyDGgPiAJBVWNJ18@sashalap>
References: <20241028062258.708872330@linuxfoundation.org>
 <20241028062300.638911047@linuxfoundation.org>
 <b80395aa-5e1a-4f9c-b801-34d0e1f96977@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b80395aa-5e1a-4f9c-b801-34d0e1f96977@kernel.org>

On Tue, Oct 29, 2024 at 06:59:55AM +0100, Jiri Slaby wrote:
>On 28. 10. 24, 7:25, Greg Kroah-Hartman wrote:
>>6.1-stable review patch.  If anyone has any objections, please let me know.
>>
>>------------------
>>
>>From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
>>
>>[ Upstream commit 0388a152fc5544be82e736343496f99c4eef8d62 ]
>>
>>Convert status parameter for ->dcd_change() and
>>uart_handle_dcd_change() to bool which matches to how the parameter is
>>used.
>>
>>Rename status to active to better describe what the parameter means.
>>
>>Acked-by: Rodolfo Giometti <giometti@enneenne.com>
>>Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
>>Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
>>Link: https://lore.kernel.org/r/20230117090358.4796-9-ilpo.jarvinen@linux.intel.com
>>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>Stable-dep-of: 40d7903386df ("serial: imx: Update mctrl old_status on RTSD interrupt")
>
>As I wrote earlier, why is this Stable-dep-of that one?

Here's the dependency chain:

40d7903386df ("serial: imx: Update mctrl old_status on RTSD interrupt")
968d64578ec9 ("serial: Make uart_handle_cts_change() status param bool active")
0388a152fc55 ("tty/serial: Make ->dcd_change()+uart_handle_dcd_change() status bool active")

If you go to 6.1.y, and try to apply them in that order you'll see that
it applies cleanly. If you try to apply just the last one you'll hit a
conflict.

-- 
Thanks,
Sasha
