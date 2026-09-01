Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643D9414DDB;
	Tue,  1 Sep 2026 15:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788275268; cv=none; b=cpkmGRGu19I5eYrGoV8VNa6WlVwkJ4pS1P3u9wS23ULU69IYzTSw08mLGak+xX7GSet2GSm0y+WeIFLGLh2H9EfBkmyZ5Ycqo9d2n6pV5Kh4FJIg2vP0NJMbi3s5JYxkQn8wlSqWo/cWwfNa8UrtjmmI5ds5BKPZn3UvemQynGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788275268; c=relaxed/simple;
	bh=QK+LBpaZKtKRLPRrE8ETXxHcpoTF4GZ3WUJyT59MwM0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M26BcxKXIFb8ov88aatUCuYNgrLaHEaewAC1O8QzC8iZbAIWhZr3pIGMUyJ73NfxtVzXNtGW+E3TH4jYHp1jy2jQ+DWSt2maCVy/ZEYA0Ci4HNMqa42JVNyYnb77hziZW6zyMSJkY087yth+zXSSEtIZjwwUdaRTmePpbM1Tw18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iJ9fgcd/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iJ9fgcd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FFB1F000E9;
	Tue,  1 Sep 2026 15:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788275267;
	bh=urG2brwJoQHtMVrzl8UUHq0yWLnkCZwfeyADZl5CciM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iJ9fgcd/UxyfrKXMhTRviEic3Wjvup/2bE7OV3krdDqI15KU3ZPfcW7nkkP32/AT5
	 Cky04oH3SqNx9CSdxyskURm6V9HRnUfdVIBr0PU3GG2p2qSnI7UjI8xERx/sWXHk6k
	 rUOM/Ayd6lhz7htlFGTQJkk68IAvsLoW6F6g84qYleo9zVwMgA9z+NddqFeoOcvsjQ
	 geLsu9soOlhljSQf35yhIJ4lrL7hiWxNMdCKNdYge0jJ5QTPNZDyzLk4/WhSTkvhYZ
	 y/kMWlXuJVBTLoAjYY0aHLgClJp4LSk826tUghuMJDKzkhLUsK1g7x0ntfgXscM5j9
	 zg5MEfJo96pUA==
Date: Tue, 1 Sep 2026 11:07:45 -0400
From: Sasha Levin <sashal@kernel.org>
To: Petr Wozniak <petr.wozniak@gmail.com>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	maxime.chevallier@bootlin.com, kuba@kernel.org, andrew@lunn.ch,
	hkallweit1@gmail.com, davem@davemloft.net, edumazet@google.com,
	pabeni@redhat.com, linux@armlinux.org.uk, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-6.1] net: phy: sfp: probe for RollBall
 I2C-to-MDIO bridge in mdio-i2c
Message-ID: <apbqQRSj6oAFw0Wl@laps>
References: <20260831133314.4125787-466-sashal@kernel.org>
 <20260901052816.3815-1-petr.wozniak@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260901052816.3815-1-petr.wozniak@gmail.com>

On Tue, Sep 01, 2026 at 07:28:16AM +0200, Petr Wozniak wrote:
>Please drop this one from AUTOSEL.

Ack, dropped.

-- 
Thanks,
Sasha
