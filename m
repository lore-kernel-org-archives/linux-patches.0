Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF3D37C906;
	Mon, 29 Jun 2026 04:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782708059; cv=none; b=lZx+Ckj27e4JoUQIwuHjIVOlnJFzIIyMx7h2SBJDLRGm7KWRfuMERn5AorlvWvWy+6HJJuaAH2Ec3Yc1vJ3WleZN74ylJdhJZKfJF9V3hz4BNazuZ9lCnFVQU3dULC0Q5KD7IRlyJ4HhWf8fJsqVTKx5rMgVYBN5/2KPlGZJ8Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782708059; c=relaxed/simple;
	bh=GbD7Yt0R73XGNv2oV3X+HxcHQQQCo8Re9ZwX8wAL7RA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Khr5CoMVtVRlQE267xJJScgZwvGg0KAHHQZf/FPFxW/Wp2kPiWDs6TCErj02EKZGe36ifVY5W32nviKNrZhzhy+dVArsPwBA06HnT2XUq+uVngiewWNSvMltTlzOHsgi/ovNTwvgoflvZGYJbOrh//WbxG/vpBnrjPsQ89VaMlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xk3zsgAT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xk3zsgAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620541F000E9;
	Mon, 29 Jun 2026 04:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782708058;
	bh=juRt5His1elSw5Wu+cmbKhJ8HAatx2f2zCsUzDUWQn8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=xk3zsgAT8y7hNSQUE1z+L6lI/dmLJpACUq8cUrbco9t9+jsunD+gWNgNWnxOQoWB+
	 jBFqsfaZJ+h0KFM+nThBeP0juwasHDe0fkyQXjF7ulwUSu4F+BTIUvZs0ASpf7OXVG
	 fqq6wIwgx2jLgJqTVY8unat/j1urQijhWAcLOjxk=
Date: Mon, 29 Jun 2026 06:39:43 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: maher azz <maherazz04@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 7.0 345/461] vsock/virtio: fix zerocopy completion for
 multi-skb sends
Message-ID: <2026062933-storeroom-amusement-0b66@gregkh>
References: <20260528194646.819809818@linuxfoundation.org>
 <20260528194657.359703301@linuxfoundation.org>
 <CAFQ-Uc-wu8fbTDXhtyODCz36_1DBue5ay7V2LpzjrUgHs+0WvQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFQ-Uc-wu8fbTDXhtyODCz36_1DBue5ay7V2LpzjrUgHs+0WvQ@mail.gmail.com>

On Sun, Jun 28, 2026 at 08:31:35PM +0100, maher azz wrote:
> Hello,
> 
> Is there a CVE assigned to this issue already? Thank you for patching it.

<formletter>

Please see:
        https://www.kernel.org/doc/html/latest/process/cve.html
for how kernel CVEs are assigned.

</formletter>
