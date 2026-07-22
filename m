Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE16466AE5;
	Wed, 22 Jul 2026 16:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784738614; cv=none; b=qOshuBNNdqCAZZKkZUKsv9A6Mrk6QMKQVCi/4wSRMhKgfsf7R7vOJD23zZpsqkonslglhRqVSudLkB6lzoJvp6Uz8uGXd0Qt0uhsXfv0WzDk7NEcZlsGH9L5l2PHd2ULIiwNaqa5Rt3ahdNjUZcaF2fNAgqwdyL1I05eI9SH3OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784738614; c=relaxed/simple;
	bh=4mvVr6++11QMRYDqG1NbeQF3kpqsc+ecII9T/vYzrZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEtinIqWI/tI+f6YUz78dvEfsTvETM0PqoZV3SogSqHkC9MsyUgU4wTUduJEYrABASC/YWxSJU92tdeKA+HpCmfDdiNyxwKXYM09s0EZ/hei0Lm9G/VBjFgyrPLnzLrggcuw/LAF8YOjyZnHZAUAQYGl120sD3T8b250MjiuToM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Scurq7T9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Scurq7T9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2091F00ACA;
	Wed, 22 Jul 2026 16:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784738605;
	bh=X0tLg/oL51AFuN+0Akdy5oAyb6i747wfWw4argKikIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Scurq7T9IkjPv00fc9sFZ/Uzr3VEee5Ff4fF3eIUw4dJ9a4aVgCL+2tCwPq3olfPg
	 QK5yiFJ+XDmiV0iCvj+Qr1XFWIvmp6Ye8d7jba7VWu1TqOqnB+KFZvkkFqlfk3XrzL
	 TR7N1qtC6jgU86i2RBuWE2DCk8yRhnZAgsOHjVYEj8du30b9rLsYl0C6fqEIfYvB9W
	 l1r3k18P5ZtPOm7AtgOwTU3Cbwq9YRkSMU5ejrq/0UV9Sq6rDudsQL17u2Z6uXoqm0
	 eY9d3n00Ttfzb5BraT8CSgQKbpFwviIz60AmNDMTCyOXRprgTd+Hu5SSfapVJ9JmzK
	 XLBmfMkyLgibA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
Subject: Re: [PATCH 7.1 0801/2077] dt-bindings: net: updated interrupt type to be active low, level triggered
Date: Wed, 22 Jul 2026 12:43:14 -0400
Message-ID: <20260722113504.rc-reply-0004@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <DM5PR02MB3369B73209A7D10B584B4C5483C22@DM5PR02MB3369.namprd02.prod.outlook.com>
References: <20260721152552.646164743@linuxfoundation.org> <20260721152611.685698227@linuxfoundation.org> <DM5PR02MB3369B73209A7D10B584B4C5483C22@DM5PR02MB3369.namprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, Jul 21, 2026 at 08:36:24PM +0000, Selvamani Rajagopal wrote:
> Wouldn't this need to go in along with source code changes to drivers/net/ethernet/oa_tc6.c?
> Otherwise, binding would say IRQ_TYPE_LEVEL_LOW, but the code in oa_tc6.c would be using
> IRQ_TYPE_EDGE_FALLING. If that is acceptable, then it is fine.

You're right - the companion driver change (b542d13fab0f) was already
dropped at your request, so this binding change makes no sense on its
own. Dropped it from the 7.1, 6.18, and 6.12 queues.

> FYI: drivers/net/ethernet/oa_tc6.c isn't ready for pulling into 7.1 or 6.18 as we have a follow-up
> patches to the "net" repo that is still under review.

I've also dropped the mdiobus->parent fix (a221d3f7e3f3) from the 7.1,
6.18, and 6.12 queues. We'll requeue the whole set together once your
follow-up series lands upstream.

The one patch I kept is the FCS trim fix (a5a1d11dd372 "net: ethernet:
oa_tc6: remove FCS size in rx frame"): I verified it against your
pending "fix race condition and crash" v3 series and it's independent
of both pending fixes - the race fix targets the threaded-IRQ state
that's no longer in the stable queues, and the skb_over_panic fix
doesn't touch oa_tc6_submit_rx_skb(). It fixes real user-visible ptp4l
breakage, so I'd like it to ship. If you'd rather see that one held
back too, please let me know.

-- 
Thanks,
Sasha
