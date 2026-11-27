Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795816996;
	b=U0Z9PNqkhJaSH0BzQxKLNdYhq2xUYPx4MRg/pU21FlftH9nbGpi/q3ffSjWs9y6ie2HU
	 A3xMj2028siQkVRSyT9Pw+JU+7zw5thdId/6IBXP9XF8eQk0DEmwGPUtSAJIfqhvhkdQ3
	 G383naGTvJPs2pJJP+7BUidrq192qgBLZzVeKzlvZ7CbYHk+i3wzrqK/64gTsPYu76mtn
	 kF9Spt0wQioqGX++jXPPfoqDdWGPm7Eq7SkXyBOBWRCjSAZFKPT1z/7dtn70Teu8neF/Y
	 EjEn7gJ1aOf4WEK3YdMRGBfYJyTf5xEawMVzkwz3Zj8nVEdCudEV7VjOin9Qk84iW3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795816996;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vmEi1AupdmJ44iVBsgBWUNKnne5KCSXVxXfEHl3xpC8=;
	b=gWAvreNJ4kiz8QJY/nqQTpPM0TXIVbl76JIJeGGAC7lVM2do+pkVjRTlH8Nw/Np0I56D
	 el1ax4+D2oQWem9JtFA0649ctMczKDbdXM/UcM5dm0fUxAKOTcT//4v2cgn3BFsV00V1X
	 3iHDJ0MFNXX/todr6ut6ju/I7/O0RKx6vxa7cs1RNZHyQ4BuND78xOQ8GfPb4RepEvIL9
	 49RSK36Mj1yJGGs7Hy3pCQYW5CYCDELBLuTYBzYLxwx1qh/EZaRCilQj80ozO/ZZDzzCc
	 E7+74J1Smk6yNpXZ6X3DEXlkn2qRpEulau3mD9Zliflj9CbjbmTe3iYlBBL36jFZjCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b="Fys/4Kbi";
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1F0E606A31E
	for <patches@lists.linux.dev>; Fri, 27 Nov 2026 22:03:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1F0E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=Fys/4Kbi
Received: by linux.microsoft.com (Postfix, from userid 1216)
	id 77CD720B7166; Fri, 27 Nov 2026 14:03:09 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 77CD720B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795816989;
	bh=vmEi1AupdmJ44iVBsgBWUNKnne5KCSXVxXfEHl3xpC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fys/4KbiI1MnpPzH6kA5xf9asCoIqAchJHUv8POs6rbyzFOCOmURUWnYg4VS2Gfjd
	 Oww1beOLftS0Uu4xCArP1lS29gqmQRGEAZlPFbhOD7SMDIaPU8Y719F4PPrk4v4fr6
	 c7/PLHjk/iPNTuPrGHTQjJ3S5uUra85Z3Ohh+DU0=
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: gregkh@linuxfoundation.org
Cc: feng.tang@linux.alibaba.com,
	horms@kernel.org,
	pabeni@redhat.com,
	patches@lists.linux.dev,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 6.6 0266/3318] selftests: net: reuseport_bpf_numa: consider cpuless numa node
Date: Fri, 27 Nov 2026 17:03:09 -0500
Message-ID: <20261127220309.2088120-1-hamzamahfooz@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261118150323.389144313@linuxfoundation.org>
References: <20261118150323.389144313@linuxfoundation.org>
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

Hi,

This patch appears to be causing the build to fail. Seems, like commit
f2662ec26b26 ("selftests: kselftest: Create ksft_print_dbg_msg()") is
missing from linux-6.6.y.

BR,
Hamza
