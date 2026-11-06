Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793971203;
	b=uVbrBQJt8tteeNu+zZy25s/+DS0OZjf+9VHiMt4NBwAC6V2CHZjF/jwhlYEn8LBz9AJq
	 dQix633RKVnl+qg29PrzgXcOPjswv1kVg8yWtxe1RzEqNKr5nluR22s8Gm7wEEIN5FpGt
	 hoqU/U0Pri9tZxljT/uM4Y7AAuuAD6FElUbuQa8SZW4eDydlkBu71cvHHrSXEc9beeP2t
	 VIU27tQFAzU2DQa7V1kY674Aw99NSvD4H55GGw3D4HRbeAcZuMULRXQA2hJVc3K0iuhn2
	 umZmqOq0euwJaNRBj5dpL8pmQ9oLe6QlGyKj2LIByFoA5vXwSx3wigzY5J2sZXxyvOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793971203;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=uBrEwmWwMVRGUxT9xMvKNEUsUNa06FOjlAt33KndUsE=;
	b=IAnv2kRj8OmXZycZeApQgUonNvZY24YG18g15V4qlbPDP4jSlpUziRA8201x13YpHX1C
	 2XGEMdfKz0xHbK5DRVamFcFhTyokX+x+wkwy93mEWGe8xpluap//AgeCpS1o6FeRM58oh
	 IlFr/XAuWioBlI07/5kvJ2454C1NjaLoJBO/HS10QLxi+2iYhi0/ox1RbP1+ZSveTHefN
	 ibmiLe6FON6BKkLV4e7PgTolbAEDRJvuCPYzFQ6Ho9dWoZdj7sc4Bic8w8N3R+m/OQLZo
	 8SSHhm3tHUVPbIC5Qlnjobfc6pmEhgxBBwGubxXLO5eJ3BOJ7H633sQl9JNJtpyF3WQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HcwVOjvR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EC3606D809;
	Fri,  6 Nov 2026 13:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HcwVOjvR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D641F0089F;
	Fri,  6 Nov 2026 13:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793971202;
	bh=uBrEwmWwMVRGUxT9xMvKNEUsUNa06FOjlAt33KndUsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HcwVOjvRIK/z6IMkv/Id6zhIS/ka/SS6eceoAPJnpEzMnXSRL5qUyBFkc3ZJZUbnO
	 A8/G0tzWrNcd5VoLTBS2CK6YZ/FKXxy3hLcXh+KL/iV/6x0zhYskqfrt+thgEcAmpq
	 +MFNeawpE9yQNJtuZnf3Cdy1/B8g22WuPioJXRoIfg605dQpAAtm7hMJjXoXoSpOi+
	 lRNfHk8fKX88uPLwwDd0i+XIL4N3Ye4n87CmxsqJGUZF5l9vFIl8sBVEFIfIaP2ioP
	 eIaLOsS8HBtNZM83eIf/15vmgEgvy43DLgYErvdjoiJHmPK/bfQO7xed4dhVhAKKXR
	 wfYJlg0lj4XZA==
From: Sasha Levin <sashal@kernel.org>
To: Sean Christopherson <seanjc@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Nikolay Borisov <nik.borisov@suse.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: Re: [PATCH 6.18 0942/1005] KVM: TDX: Enable Bus Lock VM exit
Date: Fri,  6 Nov 2026 08:19:59 -0500
Message-ID: <20261106-re-kvm-tdx-bus-lock-drop@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <auyRq2HXJIfMXgBh@google.com>
References: <20261104211043.516122098@linuxfoundation.org> <20261104211109.504581890@linuxfoundation.org> <dac4e304-98e6-4e61-93f4-8d971069d936@intel.com> <2026110539-lived-blast-ef64@gregkh> <auyRq2HXJIfMXgBh@google.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Nov 05, 2026, Sean Christopherson wrote:
> Yes, please drop it.  Thanks!

Dropped from the 6.18 queue only: 7.3 has the prerequisites.

-- 
Thanks,
Sasha
