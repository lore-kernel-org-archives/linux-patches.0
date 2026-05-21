Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A0621B9F6;
	Thu, 21 May 2026 12:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368159; cv=none; b=k3Pa7BUtEuxeuJbvDfDDnyFQfPviM6DliaqFCPhyOyTUiu8emItbDjDRt0+8c2CM5wddABTjfj3z9Bt2s51VAv7s/0hU01o6jOjhpbln/oAITMzbeJWg74e4OSM9cfXn/l9JmI6WMQoiYhYHnc3zIJOsU4TWo4rBTYEtt5v+YFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368159; c=relaxed/simple;
	bh=JCJUTwb1YqOa69Zwp0Hx85gHRG/SfR5G6rknBrCxKlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MG39k3HPiZxP5BmD6t65qwJY48DMHT35zLZEhTw6bE3Eeyitjv/VfnSTiB2GTMmQYvNg3QB4jl7Sg2Ylz/e1553rKRQ7qbsfygvFv6NCMGLxyWwgXdPvFp16WDKWSZ/jtYsEno8Rj83tl9gYVU4e1qMowRSK41Bd1uif+qTPbCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lYhe/gBA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lYhe/gBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752A71F000E9;
	Thu, 21 May 2026 12:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779368158;
	bh=e+rwOYyu+7TkNNwU0AH3atZ4Q1bh0AeCjkllpZghZVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lYhe/gBAyuin0Hdd1b/Tg3Lf2kanIgBXpIByoiGTRmJrHxNUKLi/+w9xRIk72tF/K
	 U6wEJJQLNwaCvXyrLoYoL26G+GE7UQIlCoO7kXf6WL3sS8LGULLwMPkeXIrLXlhH1p
	 75f3OqRxb4j/Ce69mBGrX3lISVcjmcvqiTmGMEfhKKMAC/+sE2oqG6yuYpzT2s1tl8
	 OxW8Oxxd7TBX7AwRhjNbL+iZhwKmXazbYhP+gooOEeuFM9cvbpXxaP7ZJexHJrX2j1
	 y6GSjBVrKWRRN0AizrKhiHK7TXEsClJgjo+fbz6SaQruOMImWgVFC9/n+e+PLaaZWy
	 UPa0eut0V7oCg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Wander Lairson Costa <wander@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>
Subject: Re: [PATCH 7.0 0453/1146] rtla: Use str_has_prefix() for prefix checks
Date: Thu, 21 May 2026 08:55:46 -0400
Message-ID: <20260521-rtla-drop-str-has-prefix-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAP4=nvTUdVQN8j_qJnfytGOJMa4LaX2h3Z9-cmDopBhKE87_nA@mail.gmail.com>
References: <20260520162148.390695140@linuxfoundation.org> <20260520162158.452078806@linuxfoundation.org> <CAP4=nvTUdVQN8j_qJnfytGOJMa4LaX2h3Z9-cmDopBhKE87_nA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, May 20, 2026 at 06:58:45PM +0200, Tomas Glozar wrote:
> This commit breaks rtla build as there is no str_has_prefix() in rtla
> in 7.0-stable. [...] Please drop this commit and also the dependency
> that pulled it in, commit 4bf4ef5292b9 ("rtla/trace: Fix write loop in
> trace_event_save_hist()"), which does not apply without this.
>
> Not sure what the policy is about 56317dd01bd6 ("rtla: Simplify code
> by caching string lengths") [...]

Dropped all three from the 7.0 queue:

  - rtla: Use str_has_prefix() for prefix checks
  - rtla/trace: Fix write loop in trace_event_save_hist()
  - rtla: Simplify code by caching string lengths

Thanks for the report.

--
Thanks,
Sasha
