Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBFF156C5D
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 06:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713939847; cv=none; b=HNT2Wrf9Ju1YBd3U9HV/NeMeG5Kki50efmo6+JpU/8AC0ZpLWHLM9neXia7nYk6mhPMInoBt5QXM0c1bJ8Ekz4fvfOzj94EBAWesDTUwwx4OZ06PhMR5QzS1GiP6R+5xtW/qitEPFFx3AKCwlMFjJUxcHr4ye7219DIaWJ59ZJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713939847; c=relaxed/simple;
	bh=TfEx6qd91z2uLEUWKW9RPcV1tYG8MZ+Yacuywdp+ETg=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=RJZRkNYbgd3UPNNTcejmrOfIhoEJ0gqckk7VM88GbjeQRJRXXCFSSnwTzTwUqgKmRnUmOhxPerjP1L8ZuIFmAtHZNDwtvAJkrkP07Xd0VMznBuZFwmpfQi7oSXbab9F2Wk1k23RHbziY6VvgxytHx0jqyyHylhN/tAMGBGMdPHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=herMSuKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="herMSuKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9966C113CE
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 06:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713939847;
	bh=TfEx6qd91z2uLEUWKW9RPcV1tYG8MZ+Yacuywdp+ETg=;
	h=In-Reply-To:References:Date:From:To:Cc:Subject:From;
	b=herMSuKq9O+IfNQ7yb9wslgdZvsVOuB4o8TcVZGpm9qqRL37bATkvdiljrgWPGqi/
	 8ZjbzgazKybqUln7wJFLh6nbr22B7mS2C9+rwl+OJrYyQS8cwE3IWgSXkvhfozV9lG
	 2JiY5v4aJ++4vV1E1cu//3t6i5Nt59DK6n10KFgieqFIIKwyn2tyT/q7QkgE2uQLMs
	 OTXA7b9oBKfpfPHKbd1gIYVFb80l5VfNmChuOihv+zPm8QziElnPAKmoWrV/X2N+NN
	 yLVobQNsaUIGlRbNPZ1QgmRJGLuZ3dQs/KVsJD3Jz5G6JEIBPksKnpRXkZKCHTxhnw
	 y+JxLKM+x2AmQ==
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfauth.nyi.internal (Postfix) with ESMTP id EBAF51200032;
	Wed, 24 Apr 2024 02:24:05 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Wed, 24 Apr 2024 02:24:05 -0400
X-ME-Sender: <xms:haUoZj0HtSW5NZkWO67opYRYJeLCWfBbRQAhdVil0s2p-bfK62B1Lw>
    <xme:haUoZiH_xowfS7po7IM9g20Jvvr1NllsOjxhgLHg11Nnt2We27EIer1Q9b2zar_OW
    REivgws8UGsW8_cov4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrudelvddguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugeskhgvrhhnvghlrdhorhhgqeenucggtf
    frrghtthgvrhhnpedvveeigfetudegveeiledvgfevuedvgfetgeefieeijeejffeggeeh
    udegtdevheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegrrhhnugdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidquddvkeehudej
    tddvgedqvdekjedttddvieegqdgrrhhnugeppehkvghrnhgvlhdrohhrghesrghrnhgusg
    druggv
X-ME-Proxy: <xmx:haUoZj6fvoElrEKiwo450qHnff4c7WFv057MNQK-xKwUI_hupW4iAQ>
    <xmx:haUoZo3tRldPOrRAmbP-My2sbh-NQKIoJdWyJ0ZRI5BnSkeVwehBeg>
    <xmx:haUoZmGX32LpZW9Erp_CnbWj5GXe9VfsMNnJUFJ_dQp_fPMn_myPBQ>
    <xmx:haUoZp82hyfsMUjrf2WDejTfwLKX6eY_Z2HyAcaTpeedEyckASMjHA>
    <xmx:haUoZjmt1v5LllEcnB062A2BkMlUaJY86OW7bLj8vi_huCGa3JrwRA8R>
Feedback-ID: i36794607:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id A08C2B6008D; Wed, 24 Apr 2024 02:24:05 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-386-g4cb8e397f9-fm-20240415.001-g4cb8e397
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <a3f702a6-c6b2-46a5-8c15-f048e30dcd31@app.fastmail.com>
In-Reply-To: <20240423213855.355112439@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
 <20240423213855.355112439@linuxfoundation.org>
Date: Wed, 24 Apr 2024 08:23:44 +0200
From: "Arnd Bergmann" <arnd@kernel.org>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "Niklas Schnelle" <schnelle@linux.ibm.com>,
 "Bjorn Helgaas" <bhelgaas@google.com>, "Sasha Levin" <sashal@kernel.org>
Subject: Re: [PATCH 6.1 065/141] PCI: Make quirk using inw() depend on HAS_IOPORT
Content-Type: text/plain

On Tue, Apr 23, 2024, at 23:38, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Niklas Schnelle <schnelle@linux.ibm.com>
>
> [ Upstream commit f768c75d61582b011962f9dcb9ff8eafb8da0383 ]
>
> In the future inw() and friends will not be compiled on architectures
> without I/O port support.
>

This was only a preparation patch for a coming change, and it
depends on commit fcbfe8121a45 ("Kconfig: introduce HAS_IOPORT
option and select it as necessary"), which was not in 6.1.

I don't think we want to backport fcbfe8121a45 or any of the
HAS_IOPORT changes after it.

    Arnd
