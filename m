Received: from sipsolutions.net (s3.sipsolutions.net [144.76.43.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65276FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=GsEYU31uPgITeejODev3lyT2zUtc5JdTy1BZ27nlYCc=;
	t=1673890768; x=1675100368; b=ZFfC8wMSXt6eXdOCuyvllAIvAt7epx5ct/gxNByLtC48ncX
	8D8GOKf6Toi+ZS9sFEIFoDezRkhKGwXBf6T5geDl2IOY/rsS4X5j9vP3G3uZZX1HYCcUDEVC34rp4
	Yk2QHBbAP5zN57eF3n7eMDJMUcg18kJUoVxWcMhf4jjWnHq7i2v0SY3wpYXO4HzEWLXrSnkdwpn87
	cnGMNWfIL8nqdfw82XewHXlIt5oIEKvQoebpl+n/3VqAy1ON0pB2vtZWzHUF9cpeFY/DT/VIaxWem
	16QKkUo9sY2zyN88xWk3KnMuKBuPBUNL6wJbOLzchF073wdTka2aUb1jiFHPyErg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <johannes@sipsolutions.net>)
	id 1pHT48-003iXM-21;
	Mon, 16 Jan 2023 18:14:36 +0100
Message-ID: <eddd4836e1f1835ea887ed91e49bb5e6ab65395f.camel@sipsolutions.net>
Subject: Re: [PATCH 4.14 097/338] wifi: mac80211: fix memory leak in
 ieee80211_if_add()
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
Cc: "patches@lists.linux.dev" <patches@lists.linux.dev>, Zhengchao Shao
	 <shaozhengchao@huawei.com>, Sasha Levin <sashal@kernel.org>
Date: Mon, 16 Jan 2023 18:14:35 +0100
In-Reply-To: <20230116154825.125747074@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
	 <20230116154825.125747074@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Mon, 2023-01-16 at 15:49 +0000, Greg Kroah-Hartman wrote:
> From: Zhengchao Shao <shaozhengchao@huawei.com>
>=20
> [ Upstream commit 13e5afd3d773c6fc6ca2b89027befaaaa1ea7293 ]
>=20
> When register_netdevice() failed in ieee80211_if_add(), ndev->tstats
> isn't released. Fix it.
>=20

Please drop this wherever you still can - we just reverted it because it
was actually based on broken analysis.

johannes
