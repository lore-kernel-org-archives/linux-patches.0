Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9537831E0FE;
	Mon, 18 Aug 2025 13:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522216; cv=none; b=rMSCkjpaAMymrY+3xRyDU+27s6OUzAUHKOSBzZKtkznOqO8bjeKCp9WWkpa6kmIj6vqSfFUveLrrbXmuFfURj8V7KaTUHlNXTlGJ+VH3RdeNLLxjQKV/9kRMtBnEh5FOru0FU0fbaNHEFuKhOxdCyzERxaWjM0//YdfC9cngHII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522216; c=relaxed/simple;
	bh=6xy+AKv1DbFl2sJUD8fEdcj0KODhR17Yd7BrWIteH78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nTThJIg7fDpjcWO8XulZu1fTt8vsASAMNcOiCqD8hu77P+8QhuZcdqY5xI4mGOKLzLVUX+jp+2aAivI2Nu8kRbAum2NWi5sNINEGVxEhzN+kOmJfXRXnJbpTgZR5N9WpG+U37+y/UOcFr3dc3tF9WdDmv21J6gR3RkBZoLRc0us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMJsPB2Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMJsPB2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0422FC116D0;
	Mon, 18 Aug 2025 13:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522216;
	bh=6xy+AKv1DbFl2sJUD8fEdcj0KODhR17Yd7BrWIteH78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMJsPB2Y9Y4Aur+Jqbvce03xJS68f0unawCw6MS0ea7Kr0imTvIzpkN5BxLcWcOVv
	 Jo3Vu7iLiCzS5cNALiprh7X1SON4N+JL2uoT/eImceDerALEATZEPiQVqdMRju5tKK
	 J554E1kYrVrrvF1LboL2bbE2HPStdQpaHFkxrzEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 249/444] net: dsa: b53: fix b53_imp_vlan_setup for BCM5325
Date: Mon, 18 Aug 2025 14:44:35 +0200
Message-ID: <20250818124458.160320915@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit c00df1018791185ea398f78af415a2a0aaa0c79c ]

CPU port should be B53_CPU_PORT instead of B53_CPU_PORT_25 for
B53_PVLAN_PORT_MASK register.

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Link: https://patch.msgid.link/20250614080000.1884236-14-noltari@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index eacd7c325530..fef265521e8a 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -527,6 +527,10 @@ void b53_imp_vlan_setup(struct dsa_switch *ds, int cpu_port)
 	unsigned int i;
 	u16 pvlan;
 
+	/* BCM5325 CPU port is at 8 */
+	if ((is5325(dev) || is5365(dev)) && cpu_port == B53_CPU_PORT_25)
+		cpu_port = B53_CPU_PORT;
+
 	/* Enable the IMP port to be in the same VLAN as the other ports
 	 * on a per-port basis such that we only have Port i and IMP in
 	 * the same VLAN.
-- 
2.39.5



