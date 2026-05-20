Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5F917A2FC
	for <patches@lists.linux.dev>; Wed, 20 May 2026 18:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301960; cv=pass; b=dIiFmvSeW2hXXTej6ufZWWtTQi1FkBN0tHixPYVT/aUSxfs/GOhbqIJtDdqXSTi/AIJtfrwhwh6zw5hkLg8nzXsqjPp2YdugBHFg+Ve3XC0bbLzujffw9ENcaK2+2mSc1tRVjxCS2lESP1Q65I2/gp+bgVVHqOnRiD07JPP6G4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301960; c=relaxed/simple;
	bh=Iyx8dnBn0kYwBZ0SP5ro0ffqifZw18RfJZjsNcvONIo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K9pHlx1qWmQPicMhy5ASEv6LTbq8mZQaz8t3Vl9Ay9mdRQRQsUtLLyVkqV5h0wNK1erIA095G9cIoEmDo1izuCHod3zMmStnQ6v7UdlKaA+iflCKXrnb1LYHvsQZ0UPAFWdGxz4PhI9b37IzSSiTquk4FNmMCN3plO8SlBKBH0c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W6RmlaMC; arc=pass smtp.client-ip=74.125.82.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W6RmlaMC"
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-134fe980658so6938862c88.1
        for <patches@lists.linux.dev>; Wed, 20 May 2026 11:32:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779301959; cv=none;
        d=google.com; s=arc-20240605;
        b=YkQDYwtZY6MUR04qlQukP7tJv8fjsu9kbRhMjpA/E/+FY6q6hcBsRnQY+9p7N8X8kP
         NasTReJuZzvDQUxjJbuUirUq604iOUjwP1z2ZRTeaJvXfGMDSHwVQ0/tduy/JvNZY7Ph
         fsf/6M1qSdUHrywwtnE0u0oKVp2vGo8BNsJILuTq0uBTkZi27EfRnMTu5I1VcatHvykb
         PVmJbyBAqYH/MQUHH7Yd/vVc5dPVixN+3LB7yiEZPNKcF6RpSUKkYiekR61oHDOaeCPE
         xWC3A9VfRoBzPzVmsnrmcSiIdrroAkvppFWhc2zlv/8rEVR6WMmyS22vWRbEfrHp2HW1
         GLcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YcognBcrpWvnvJQi1n7S900RyaKYlaiNOYb48LzSaSo=;
        fh=uG7oBvh1O3h7dk/wWOE1bGsLu+cjcvaFfaI/jDK5+cY=;
        b=UvgfuFMsjLMwlBfqtOh5fnxEw+ctDGMW9ctRw6nyFAm/QcNOOhMW7x2qq4KXLgYlSJ
         uW2Z5CYvTUgVnuO6o4IwpAl+EkPLEk+BeMQ3PuN8iybF/A5G7B3MU4MRkKT/qTTJXDDb
         8ODeK2f9QEPDTOH0eqdoUE01nZuoVdW9pSTjBxTe4UxcFF914cTvUgqhE6qkc0jKb7nW
         AtC8NQ0WStvulpi1hbfrzIqB2zt1JzdGpRyjhNV7g455AEampnGuOrnlHiUns2SoCwLR
         lZQPUK33n1f7o2YFx82Hj13k4j1FmdipTSE99EIcfHEg2sGd4IVGZX4dg0osB5ceWvHY
         MYGA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779301959; x=1779906759; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YcognBcrpWvnvJQi1n7S900RyaKYlaiNOYb48LzSaSo=;
        b=W6RmlaMCIdMDWYnio9KDVUsZK8xp4e3HzMQllnHUzniQjW/gr0t9bAZrTJ97mL9N88
         PivBZtjGM11CQeHjh+YrsHIHlE1FKkd9d+tY04AIokIfeBXCBLFCcLAgdmrwsgbbrpwh
         cw4mTOAbEvPhMg6yn6MqsQNd0QDIAmE1vvcnsy9ClAWJ7loTVdvxly2DEcpxj/+NmVn/
         +rquBzyERmjFh4Q27ILnyIGOHLZYvQrGRqJptlvp1O5yP8k+qhLbH2qYtBpL03/b/wXo
         wYlSM7rVvf3AKZDqBVmoBepO/QliJdKP6gdkxcV1WJ6ElzpA7WYhveM5egqBxc56dIWw
         BR6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779301959; x=1779906759;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YcognBcrpWvnvJQi1n7S900RyaKYlaiNOYb48LzSaSo=;
        b=APZxsFxIEYKfCKu8W8O2D7l6ZgOnjNxaTfDLu1wdH1mBN2ZPbanUbjrQ3KQPkTEj/W
         5skdoh+/dpxWOXgoVLkrXNYHDg5Z+crMCSW278ANKvhJkzawos/+RTRSAUbsZVe7js49
         ZRW3oZTgvLzkbbjKZSH+TjHYjPVVUbuOaKxCiadhfTQiP/a9Lf/782vLmqR3OmQuOliF
         SryLlV/Qp8PxyZfQKbXp5F+pFVj4S1xhwswMwQ6xpdt16e7j3nIrr8wTSdmvw3zHb7IA
         V73sAj4lfJ0wGNUM4LOH21GZzfMhYg9qPZAwUEQSI7uLGy2Yjjc2Z80lLVc07JObLK6s
         ROiA==
X-Forwarded-Encrypted: i=1; AFNElJ/NsbELS3MdpVTgnAeI09q6Q2zc3dRbVijRWyx4t/uVput9/46aNqadqDWwa2EYyumCy1LcJAcy@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+n+fCP1lW0J0aTQUYc3su7agGfe6h2hFVkg494cjB4JJ0JY9u
	PmX+xNzeosODzOB7lMJHmNRUODDOfIeQggPavp6Y63TSQ2HWpB3D908tgyO9lLMK2WqlOIlWpfL
	Ud6CHywZ14rRCjW1DPJqZzWz9l+zmqUQ6CSuT32M=
X-Gm-Gg: Acq92OEIjNDlWjC/2ycd1/pn4DmadCLobhutU5af5+1sEBN7HEHTVCMoislIhFfAO0A
	RnA0yDGykAU+MK9tONFGYNVz4v22rUTCdHqhY7JLoYZi+T7818WO5dL0kvSx060aEX+Vq++0j0Y
	dlVWlE0J4H8LbNNetFXS2J5S3p5MRbHpVVrwI1gHeiduzwogMwi3BdY4vZrP1T1InL6bBNwwLcC
	zohd9bAdnSM2AEz6XqaOhDu4nbR2ZsTENCSxIuOogv2+BGUD6OxGOcXvkr/qVg+XKQ53hUCeuvQ
	2RJHTgq2QrgjuozANtFFni0Xl/y6qv3Zp6VW/OlnDdlsoNubGRQhDgrhDdZQx4+bvD7ZNiSDKPa
	tP+R6bp7MuEB0f1TTV8hCwvWebsL1aGiDI5oUxOv8/Av0qw==
X-Received: by 2002:a05:7022:fb09:b0:134:def6:e73f with SMTP id
 a92af1059eb24-13505433a9fmr9856930c88.21.1779301958047; Wed, 20 May 2026
 11:32:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260520162134.554764788@linuxfoundation.org> <20260520162135.687777470@linuxfoundation.org>
In-Reply-To: <20260520162135.687777470@linuxfoundation.org>
From: John Stultz <jstultz@google.com>
Date: Wed, 20 May 2026 11:32:26 -0700
X-Gm-Features: AVHnY4Kgob_5L6wVdbe5hNklqyGV6AbNPh2DYL9FVbYHSV_a8rpBk1d5OS6HIcU
Message-ID: <CANDhNCpZWMk6GWubK8+E0rxKUqtuhOtrjqxunS=Kmho-UbR0UA@mail.gmail.com>
Subject: Re: [PATCH 6.18 052/957] sched: Make class_schedulers avoid pushing
 current, and get rid of proxy_tag_curr()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	K Prateek Nayak <kprateek.nayak@amd.com>, Peter Zijlstra <peterz@infradead.org>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 20, 2026 at 10:18=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.18-stable review patch.  If anyone has any objections, please let me kn=
ow.
>
> ------------------
>
> From: John Stultz <jstultz@google.com>
>
> [ Upstream commit e0ca8991b2de6c9dfe6fcd8a0364951b2bd56797 ]
>
> With proxy-execution, the scheduler selects the donor, but for
> blocked donors, we end up running the lock owner.

Eh, I'm not sure of the urgency of this going back to 6.18-stable, and
I'm not sure its worth the churn.

Proxy-exec is still in development and requires CONFIG_EXPERT to be
enabled, so I'm not sure how many folks are actively using it with
vanilla 6.18-stable, as it wouldn't bring much benefit, and even if
folks are experimenting, the downside of not ideally balancing tasks
isn't likely to cause a crash, just not ideal performance.

And I've already pulled this change back to android17-6.18 where we
are using the full proxy-exec series,  where the actual usage of
proxy-exec is likely to be.  So I'm just not sure this is worth the
churn/risk.

thanks
-john
