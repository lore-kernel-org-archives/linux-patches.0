Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4447B384228;
	Sun,  9 Aug 2026 15:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786288121; cv=none; b=OUmQDProXaoqJTzJPEfHYoEyiSpbTtQgNOvCY2zic+YXALYhWgnp+1sZRNZgusLvnoCNQolRKYDng+Hy6RvshvgqnquH2DWqWX+K6yJGu0eXUBW1HtNLo4lq5Cuwf6NYa4+cG5tsS94NzdR0elxWwndH8U0aESnB3P/NQ5o8hiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786288121; c=relaxed/simple;
	bh=uVyFNbAydXVcOXqEoIbB6XNEVNr2+ioHjszQPcvc7CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qUQe9l1eN6rqK5BXRQ4UJG3THy97BPnwQLwSRkmmpobV91y50fWj9jDngalNyduzgCMmO50u+VzlSFwivMaEPj/uyJ2rFhe56rUyGOHprzdZzxV1yeuv5OIshM+9Yl36lSkrNkUwLpHAoB4+PriM8KJXHrITh+bNZoVmbnt8OSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KbscRPPR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KbscRPPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BF21F000E9;
	Sun,  9 Aug 2026 15:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786288119;
	bh=vUTHfDjifbU3NWoVvPx4xceZFnQdOhGlPS5NWWI6u9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KbscRPPRo5ueMhVQHmAjqa6fr50jHJfBqCrvv313OB6PfzfGXSYHNUSJI2iUJs+p2
	 i8n248tn5Gpd1bBFOXTfZtNBjqYyAHcjqQyMRb+ZncIVTPYrdiXOsBNzHZwzWThlrk
	 P3B83QqA1BO+y6PXAtDavRLEZ9+m1VEGSP3iNq5XqtU3kW4tIE/xnMXegVG6oePguz
	 3l1t/lQ9ZJ/SxUvWA906IjYIo4WNqRNT8NdedFqtyPMpQh6pJpjMXMwb5hGcSoHNCb
	 hi5S1INOvBqmGE6pp5szPsboP2LxvezOrroCPhKbMvrJUktZQThvLA7ilEptoNiy08
	 KLORnINygbSgg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	vegard.nossum@oracle.com,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 106/337] Bluetooth: hci_sync: remove unnecessary hci_conn_get in create_conn_sync
Date: Sun,  9 Aug 2026 11:08:34 -0400
Message-ID: <20260809144635.1001.sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <5fcf1911-1284-4791-a678-c54c544aba27@oracle.com>
References: <20260807143418.516897842@linuxfoundation.org> <20260807143420.836222269@linuxfoundation.org> <5fcf1911-1284-4791-a678-c54c544aba27@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Sat, Aug 08, 2026 at 10:38:00PM +0530, Harshit Mogalapalli wrote:
> This backport nevertheless removes the worker-side get/put pairs. That
> leaves the queued work without a reference if connection deletion races
> it. I think 6.12.y misses commit: 2f5d635ad5906 ("Bluetooth:
> hci_sync: hold conn in hci_connect_acl/le_sync() callbacks"); I think we
> have to either queue this prerequisite or drop this, thoughts ?

Good catch, thank you. The same problem is in 6.18.y and 6.6.y, not just
6.12.y. I've dropped it from the 6.18, 6.12 and 6.6 queues.

-- 
Thanks,
Sasha
