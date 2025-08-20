Received: from sender4-pp-o95.zoho.com (sender4-pp-o95.zoho.com [136.143.188.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191BA2475E3
	for <patches@lists.linux.dev>; Wed, 20 Aug 2025 18:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755713082; cv=pass; b=sy9Mc5KbZFiUsDiFn2P/LvcQgNq1XQEsp/OK4bjr/Cr2N5EO+CBMZZrpV4Z64rNN4F2pCVoqLwbnNlbXMiYnwINaX5i9acJvI297ZMwSwlW1y5jjsvj416kszPZ2mJHI2yeXxWz+bT72l8JbOQeQIuzW2CuA3fxfgqKHATlqNws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755713082; c=relaxed/simple;
	bh=/sDWh+ae1Ou2f62jlvnClk0tKa69LqzmgWXUDZ9KZKE=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=KAvzQPCF8iXLex2uwnVNWhp2sNJBwyeMw/2NsVv+V6BvW1Du+K7LlmxVgBaA5NAWWpko5rtXhhvHZdaQo6s0IozWbaTYSU0ZQ3TABdvFvk4nA7mlr9ktFnheDb6+cd1CRbKAgfmiq+dhC98LzCjRPodDjeN1W7qCnvSnYbtRHlo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com; spf=pass smtp.mailfrom=zohomail.com; dkim=pass (1024-bit key) header.d=zohomail.com header.i=safinaskar@zohomail.com header.b=bPyf7Mtz; arc=pass smtp.client-ip=136.143.188.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zohomail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zohomail.com header.i=safinaskar@zohomail.com header.b="bPyf7Mtz"
ARC-Seal: i=1; a=rsa-sha256; t=1755713077; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=gmjLuJWmCFaVTZV8qHgBbNEMLola228FfioLR0EaORcUqx7l5pDCxjqpXufi5Domje7jf1+/TwZ1Vq0BPQhIobeuh98s6OG0hWhZ6cHifSlu9TuJVZqWIAk2yJxyctxQ2V53/3dsBNh7sWYmysQVfKdH+RlysSrhPfiEXWrhSvo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1755713077; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=vlpCUGWUTc9QKHO0QrhzDZvMmYUbPjl3HH6kmLTP4r4=; 
	b=mVDd4nMKIAwx6MH7gGhzJOIRjuYbz2Fj3kBDLlu3ZD27xfkwc1Mj3Pma5hQ/Ne8yXQ/eYfhJVPdDj00L0IGt15oTLTkk7JKVfMLmz3cxbaJi0MNrRzNm83dJWYCi+4bHsI7+C1fCorMsbz+Bt7q12LL9apV77IJKbuXS/yw3viw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=zohomail.com;
	spf=pass  smtp.mailfrom=safinaskar@zohomail.com;
	dmarc=pass header.from=<safinaskar@zohomail.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1755713077;
	s=zm2022; d=zohomail.com; i=safinaskar@zohomail.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Feedback-ID:Message-Id:Reply-To;
	bh=vlpCUGWUTc9QKHO0QrhzDZvMmYUbPjl3HH6kmLTP4r4=;
	b=bPyf7MtzvyzcRPgVR6BH0+nw2b8QDuDoGqa++m8Y6jrwGdiAtxbpQUjJwfHfFkND
	7z0ZBR4aejXcm7rbnGXo70qJxkylkpxUrh+UslWxpPcu/jy2znq079rozApbzpUW2SD
	Ocxjkd748WMt78r11l3LWohttzpC2eZobffT47nY=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1755713074819207.41199568602656; Wed, 20 Aug 2025 11:04:34 -0700 (PDT)
Received: from  [212.73.77.104] by mail.zoho.com
	with HTTP;Wed, 20 Aug 2025 11:04:34 -0700 (PDT)
Date: Wed, 20 Aug 2025 22:04:34 +0400
From: Askar Safin <safinaskar@zohomail.com>
To: "Christian Brauner" <brauner@kernel.org>
Cc: "Alexander Viro" <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>,
	"cyphar" <cyphar@cyphar.com>, "Ian Kent" <raven@themaw.net>,
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
	"David Howells" <dhowells@redhat.com>,
	"autofs mailing list" <autofs@vger.kernel.org>,
	"patches" <patches@lists.linux.dev>
Message-ID: <198c8a77675.10b9b26b778918.8128243883083916952@zohomail.com>
In-Reply-To: <20250819-handlanger-explizit-b0a0debe7bc6@brauner>
References: <20250817171513.259291-1-safinaskar@zohomail.com> <20250819-handlanger-explizit-b0a0debe7bc6@brauner>
Subject: Re: [PATCH 0/4] vfs: if RESOLVE_NO_XDEV passed to openat2, don't
 *trigger* automounts
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Feedback-ID: rr08011227ac129564321ca7bb17d63d3500005ff1fa0c0c4d18bffc21e945127eca8428f7d8eb0e8c9cd30a:zu08011227c6b2156a51bedb40ba3c2e2200003f4effd2e4fd78b62fb82d1ac800486dcf4de82a7e37f2d22c:rf0801122b3abc50c9a4e0572daeeed258000046f80cfb5ec8f9865359dc41cdf76db9800c462dc8116d77363e98ed43:ZohoMail

 ---- On Tue, 19 Aug 2025 12:24:22 +0400  Christian Brauner <brauner@kernel.org> wrote --- 
 > Thanks, this looks all sane. Once you've addressed all comments I'll get
 > this into -next.

Thank you! I will write next version.

Please, also look at this Lichen Liu's patch:
https://lore.kernel.org/linux-fsdevel/20250815121459.3391223-1-lichliu@redhat.com/
I want this patch to succeed.

--
Askar Safin
https://types.pl/@safinaskar

