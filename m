Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA86E8592F
	for <patches@lists.linux.dev>; Mon, 26 Feb 2024 15:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708962879; cv=none; b=Zr2PKVvZxynr4Q/qpZBOugiSqfatWwoFDrfrhl9Mf1KaLHG+Wd6lMoA4P6d09KG8CXknfq5W6yWvrl4IU3cHI9RayTiZARDoh6mlmQSSNAAYtoRiszaeBb9I39X39n4m6VTDLWeJ2Dr3HOLN2xemxP+lPX72xYAuy0aQoItK3DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708962879; c=relaxed/simple;
	bh=uKA8cFcS63jP5xi+kpE8TshkDcQDdXGd7AvHLfQ1UNM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s0OcdsmWEuobxAttbikJ800O2kqxvZ2hGnO6mUsVj+4DxPWvLQgS8rT+RFr+cgo6S/glRg9ek0+JY5AyO8bUoSwuHcTMWeoXc+badBqGfJTzLqxQ2+AEszqKxClzhN7eUJSIo6po5Hdg2fOVQfaYZ+y5Y/mMSlYu8MCtQmuGA4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MZ4Pdb3B; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wqg1nf1v; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=MZ4Pdb3B; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=wqg1nf1v; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MZ4Pdb3B";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wqg1nf1v";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="MZ4Pdb3B";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="wqg1nf1v"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 043701FB62;
	Mon, 26 Feb 2024 15:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1708962876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EGsCQ/fnCVcNvnOb2GZ5PlfH6NIJ2juObDF2VySNH9Q=;
	b=MZ4Pdb3BIFA2yzPvrDb7TkIOMRiDuQrbURpJvJccZOFpCui5Mk+at9lzGcfx8tIcLR5/h/
	GSlKcA1Qhbz7MGEqUTUFDAPNl7GLzzZ86cMlLwUhhQmb0JOykHtzJp5TT3L4iKr+mbgFDt
	StOCyQnc+MsP1JH92KtpEQoPKmy0t5A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1708962876;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EGsCQ/fnCVcNvnOb2GZ5PlfH6NIJ2juObDF2VySNH9Q=;
	b=wqg1nf1vCj6ppzs4YgE55jbx6GF0GMSOfIGftfDkEkg9QanQp3G3hjjgvxmKn5+wtQbyw3
	0aDKx8fGqgEm1MDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1708962876; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EGsCQ/fnCVcNvnOb2GZ5PlfH6NIJ2juObDF2VySNH9Q=;
	b=MZ4Pdb3BIFA2yzPvrDb7TkIOMRiDuQrbURpJvJccZOFpCui5Mk+at9lzGcfx8tIcLR5/h/
	GSlKcA1Qhbz7MGEqUTUFDAPNl7GLzzZ86cMlLwUhhQmb0JOykHtzJp5TT3L4iKr+mbgFDt
	StOCyQnc+MsP1JH92KtpEQoPKmy0t5A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1708962876;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EGsCQ/fnCVcNvnOb2GZ5PlfH6NIJ2juObDF2VySNH9Q=;
	b=wqg1nf1vCj6ppzs4YgE55jbx6GF0GMSOfIGftfDkEkg9QanQp3G3hjjgvxmKn5+wtQbyw3
	0aDKx8fGqgEm1MDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1466A13A3A;
	Mon, 26 Feb 2024 15:54:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9DfSOTq03GUkBwAAD6G6ig
	(envelope-from <jdelvare@suse.de>); Mon, 26 Feb 2024 15:54:34 +0000
Date: Mon, 26 Feb 2024 16:54:30 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Heiner Kallweit
 <hkallweit1@gmail.com>, Wolfram Sang <wsa@kernel.org>, Sasha Levin
 <sashal@kernel.org>
Subject: Re: [PATCH 5.15 372/476] i2c: i801: Remove
 i801_set_block_buffer_mode
Message-ID: <20240226165430.0e7bea8f@endymion.delvare>
In-Reply-To: <2024022630-scone-factoid-02e6@gregkh>
References: <20240221130007.738356493@linuxfoundation.org>
	<20240221130021.778800241@linuxfoundation.org>
	<20240226142935.62cac532@endymion.delvare>
	<2024022630-scone-factoid-02e6@gregkh>
Organization: SUSE Linux
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCPT_COUNT_FIVE(0.00)[6];
	 HAS_ORG_HEADER(0.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 FREEMAIL_CC(0.00)[vger.kernel.org,lists.linux.dev,gmail.com,kernel.org];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-3.00)[100.00%]
X-Spam-Flag: NO

On Mon, 26 Feb 2024 15:56:47 +0100, Greg Kroah-Hartman wrote:
> On Mon, Feb 26, 2024 at 02:29:35PM +0100, Jean Delvare wrote:
> > On Wed, 21 Feb 2024 14:07:03 +0100, Greg Kroah-Hartman wrote:  
> > > 5.15-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Heiner Kallweit <hkallweit1@gmail.com>
> > > 
> > > [ Upstream commit 1e1d6582f483a4dba4ea03445e6f2f05d9de5bcf ]
> > > 
> > > If FEATURE_BLOCK_BUFFER is set then bit SMBAUXCTL_E32B is supported
> > > and there's no benefit in reading it back. Origin of this check
> > > seems to be 14 yrs ago when people were not completely sure which
> > > chip versions support the block buffer mode.
> > > 
> > > Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> > > Reviewed-by: Jean Delvare <jdelvare@suse.de>
> > > Tested-by: Jean Delvare <jdelvare@suse.de>
> > > Signed-off-by: Wolfram Sang <wsa@kernel.org>
> > > Stable-dep-of: c1c9d0f6f7f1 ("i2c: i801: Fix block process call transactions")  
> > 
> > There is no functional dependency between these 2 commits. The context
> > change which causes the second commit to fail to apply without the
> > first commit is trivial to fix. I can provide a patch for version 5.15
> > and older. I think it is preferable to backporting an extra patch which
> > wouldn't otherwise qualify for stable trees.  
> 
> This is already in a released kernel.  We can revert them, if you want
> us to, is it worth it?

Oops, I'm just back from vacation and did not realize this was already
released. Let it be then, no big deal.

-- 
Jean Delvare
SUSE L3 Support
