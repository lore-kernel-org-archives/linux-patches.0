Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9613C17
	for <patches@lists.linux.dev>; Thu, 15 Feb 2024 03:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707969284; cv=none; b=XGhu5wQkGQTKcg+UQVxJajKtIsbAL5s6tkKTwX0aVImsdl2vEEWUuRv1kJEJd7nvaYYQvaXylR45+5RzlhDBBSSYy2Ij+CvJsNbY9U9Hg+duy1j36M31mobT+zeim/XmojnnnH6vHQs750IA7kkKBoxlXgFJTh8gFKUcnHTAjHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707969284; c=relaxed/simple;
	bh=u9GREmREsa9K16Mj/qJJepYXwLaWhgNfbB48MjQKbpk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XY5ulCOAkYrVfQ/mNZN8552AhUF63exYb03juVrv7ZW54GbUXa1ag729mZ+uscczW41SrCPNMs8YMvbck3KoTlA68eyPXdXrjJfXz4qi1mY/q1LH0dEhvjewAr3jquLNj3R9Wktm70YWKo42cKVcJKUB4r7dGlH4Wx4bN0WqaWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=u1yChdZw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QxaIbbKd; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=u1yChdZw; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QxaIbbKd; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="u1yChdZw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QxaIbbKd";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="u1yChdZw";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QxaIbbKd"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 300E91F844;
	Thu, 15 Feb 2024 03:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707969280; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5kN76w+1MfjsyiMW5EtqFNsorHmy7CzsOWoopjdKlgo=;
	b=u1yChdZw7tSy04b6f69Vjus7ecHVSfxFWVzBVEjkOjvWQURYBvJLR7ZF7Ai/sqtHrOffKH
	1Fm8Md/G1P2eNfZxAhJzgGhq8VEVwLY0dRK6JGjv5p0JTDGmsPcvdf+ujUw2cOUm2VhWNF
	lLffWvy2HU1fAjek49m0u07iUacOXio=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707969280;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5kN76w+1MfjsyiMW5EtqFNsorHmy7CzsOWoopjdKlgo=;
	b=QxaIbbKd+/HVbVptW3t9ootZU1tck9HajlzdIJR9Hbz3bhARbBbRQF3u6DdlfDOVYx5Tds
	xLH2n0Z1APTFUmCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707969280; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5kN76w+1MfjsyiMW5EtqFNsorHmy7CzsOWoopjdKlgo=;
	b=u1yChdZw7tSy04b6f69Vjus7ecHVSfxFWVzBVEjkOjvWQURYBvJLR7ZF7Ai/sqtHrOffKH
	1Fm8Md/G1P2eNfZxAhJzgGhq8VEVwLY0dRK6JGjv5p0JTDGmsPcvdf+ujUw2cOUm2VhWNF
	lLffWvy2HU1fAjek49m0u07iUacOXio=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707969280;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5kN76w+1MfjsyiMW5EtqFNsorHmy7CzsOWoopjdKlgo=;
	b=QxaIbbKd+/HVbVptW3t9ootZU1tck9HajlzdIJR9Hbz3bhARbBbRQF3u6DdlfDOVYx5Tds
	xLH2n0Z1APTFUmCA==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 2CB95139E2;
	Thu, 15 Feb 2024 03:54:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id GueuM/2KzWWjKgAAn2gu4w
	(envelope-from <ddiss@suse.de>); Thu, 15 Feb 2024 03:54:37 +0000
Date: Thu, 15 Feb 2024 14:54:22 +1100
From: David Disseldorp <ddiss@suse.de>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH fstests] common/config: fix CANON_DEVS=yes when file
 does not exist
Message-ID: <20240215145422.2e12bb9b@echidna>
In-Reply-To: <20240214174209.3284958-1-mcgrof@kernel.org>
References: <20240214174209.3284958-1-mcgrof@kernel.org>
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
X-Spamd-Result: default: False [0.40 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[4];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_NOT_FQDN(0.50)[];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-0.00)[23.61%]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: 0.40

On Wed, 14 Feb 2024 09:42:08 -0800, Luis Chamberlain wrote:

> CANON_DEVS=yes allows you to use symlinks for devices, so fstests
> resolves them back to the real backind device. The iteration for
> resolving the backind device works obviously if you have the file

s/backind/backing

> present, but if one was not present there is a parsing error. Fix
> this parsing error introduced by a0c36009103b8 ("fstests: add helper
> to canonicalize devices used to enable persistent disks").
> 
> Fixes: a0c36009103b8 ("fstests: add helper to canonicalize devices used to enable persistent disks"
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

Reviewed-by: David Disseldorp <ddiss@suse.de>
