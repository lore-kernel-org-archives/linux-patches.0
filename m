Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351B43D7D90;
	Thu, 21 May 2026 12:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779368169; cv=none; b=kgzW2syWK8jVYznmRRFuxll49mYHvpInIQVh0iQqHAPRJ/n8seeQ1HsQqVHZvDj7xMdRkeqsv1IaR+ldqh1YxNGJf+c6L4UQz9JcQKGIb13QxoQuKlMBQH8EngLAylXWembYM89NUyxTnglDqiAgG22WCxpdFSOVO5BhSg3BuB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779368169; c=relaxed/simple;
	bh=uwcRtwudW2FP2P8V2rDDPMnj5TADNxBpDd5s5gso0ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KIN2awbptoRFH1CwFCo1RkQAGhACYSK/6l1bkldO2c4NX+wXE182z0yihBb8Wen3qA4DkExL+xiiqrkSMInfT7CJSs1D9DfeT1rajBuerBwluwlWL9XWo9dMr7mtu0L8v/sRnI49KCgdITu4AjRVEH/I5nxJoSQJ/RCmzmKTJhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U4YEdDj+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U4YEdDj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE5C1F00A3E;
	Thu, 21 May 2026 12:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779368168;
	bh=uwcRtwudW2FP2P8V2rDDPMnj5TADNxBpDd5s5gso0ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U4YEdDj+zMPVkDT61xcCSbzVYEVV78OJ/q9yDxFciI1msrvmDBo3BaQ8DT5irg3o2
	 c0ZA1c4mLG7Q6xQUaYkrvk1eEpKzCnDxa/jNHfybrQznQFbzPgW6kzmRrfrOVYPuCs
	 5qMGlcswxw61EAbasv0be0t3jfrTvbCUBpA2fjQGlIVDtFq3+9LNYlllGXSUAeP1V1
	 gWNoPIznVhsWqmvziRZMlPyjPYGXSxlnyvUIIF0M5ZESigVdrlpY5xLwAE+nCuxyCJ
	 euLLoJdIGtGZAV+HMjHa97gb6JQ8/FCihJfuaiTLbs37WEp80nTznMsY3yzsl5pSOh
	 lHBmbh7c2PJJg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Peter Zijlstra <peterz@infradead.org>,
	John Stultz <jstultz@google.com>
Subject: Re: [PATCH 6.18 052/957] sched: Make class_schedulers avoid pushing current, and get rid of proxy_tag_curr()
Date: Thu, 21 May 2026 08:55:53 -0400
Message-ID: <20260521-sched-proxy-6.18-drop-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CANDhNCpZWMk6GWubK8+E0rxKUqtuhOtrjqxunS=Kmho-UbR0UA@mail.gmail.com>
References: <20260520162134.554764788@linuxfoundation.org> <20260520162135.687777470@linuxfoundation.org> <CANDhNCpZWMk6GWubK8+E0rxKUqtuhOtrjqxunS=Kmho-UbR0UA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, May 20, 2026 at 11:32:26AM -0700, John Stultz wrote:
> Eh, I'm not sure of the urgency of this going back to 6.18-stable, and
> I'm not sure its worth the churn.
> [...]
> So I'm just not sure this is worth the churn/risk.

Dropped from the 6.18 queue.

Note we have it queued for 7.0 as well; since your note here only
named 6.18 I'm leaving 7.0 alone for now -- shout if you'd like that
dropped too.

Thanks.

--
Thanks,
Sasha
