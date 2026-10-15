Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F1714900E;
	Thu, 15 Oct 2026 00:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792022934; cv=none; b=k64n5U0+/7XCLFQtxq4oK/JZ4y38AaL5mxLN42gq86xWhPKGAeLRSaOcmVs33+EFO3CKY0wj8CJCKdWlYg05DqwfAHYSFcmQLvDiEZytr91VV+6767TtFhBRkS8/rYB8TR+pWwMWS9V5bar6X2mzJ9xEoLEZAIqPHO3PTJ69bZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792022934; c=relaxed/simple;
	bh=C5poVjZSaCxvBuVzJRjR0HKQVu6d9s9Lm3qzHiyMevc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9IhEMUpmw8J84VqvUV5guX6VrRTWqjSdI/Nw+CAq+ZN3ElVcyUJHXp0p+ND/dY4BoD5ukL9I5YwjqvcTqKMG1imNoln7azik+eq6hC7Hczpowid3AhpdRHpSesJOPjWu0TEAyVjo4xsIp74qkl40w9aeCkMHAxWRGvy0eBGGPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hdDum8m0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hdDum8m0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6D61F000C4;
	Thu, 15 Oct 2026 00:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792022933;
	bh=XzI/i1ZNyTOkN/mJvAcjm2iu4DcPSfDHxJfoa+XPs5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdDum8m0bG/7kyDJ9npbKBUJM+1nWS75LNI42nJMq56SpMsu01IKJb8D92Gc34fKn
	 ocso7kiP1S1Uz558NvGrFfdCDqJ5qUXEtGVWRLnlIxI8oP/jobjxXy45OqFK671ZiG
	 wpYpN9K0Fl2k6S2Ne6sDUgvBeFviyjsg0mi+onWR1OBx5FT+0I11P513AtDJnh5/iO
	 Km4stS+HMhp5wKWK2IMIeLank86vuAKLuZsN4HajAT22vfnl6ZqUMUcD/sS9Xcipm8
	 hht/1oNJtiDmifBCgh5rReL3Ch+C4ju8gLogKlNIgjIRGZhliKIdNNMdSCJxAbU/tn
	 A1mhAxF0vtpWg==
From: Sasha Levin <sashal@kernel.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 6.12 475/497] cgroup/cpuset: Call is_in_v2_mode() after acquiring cpuset_mutex in cpuset_handle_hotplug()
Date: Wed, 14 Oct 2026 20:08:41 -0400
Message-ID: <3e99a5917c404220b9e573f7@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <abc30e0a-23b4-4955-a788-27ea7dfe8ec7@oracle.com>
References: <20261013112907.864180619@linuxfoundation.org> <20261013112919.152664273@linuxfoundation.org> <abc30e0a-23b4-4955-a788-27ea7dfe8ec7@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> So I think we need to take this prerequisite to make it complete, thoughts ?

Keeping this one in the queue. Calling is_in_v2_mode() under cpuset_mutex is a
strict improvement on its own, and the root-access race you describe predates
this patch.

-- 
Thanks,
Sasha
