Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929E51487D4;
	Tue, 23 Jan 2024 01:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972079; cv=none; b=u8oijnqY81R5Du9GFu4NilsPpe5d9vwwqn7kW+IXSt8A1DpRYcNvYbZfZAcY5UNb9BRdTIBkZiHJHT202IlplWBGjTuI8eVEudhLk0W/iVwSD9YnhNa7MWBc/5RMeYZ90LU7Z+UDT2mVIN9OK36PiYTt3N8afSXIyq8yOsvsPVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972079; c=relaxed/simple;
	bh=O5yPergo4AQa1Tx1k119NWlAkAlRhzzcaY2+TqWfjCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKg/Z96p68Uucz24uYNZLLC4ENFZ2QPfHv/8OvyX+w4zXFkXVDvNt5QNU0Yo8SxvzBnpgir8f32vuaaQ1znQ3bn8Z5Ic9ci+ZMS8l488YAzpBE4ZA/9fA7hrT+Mm2Yamgy5Rb14Xmgl5YjpsbYz9PAzNK0ZLEzSOekENCHplJas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=elo+XmVm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="elo+XmVm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCBDC43330;
	Tue, 23 Jan 2024 01:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972079;
	bh=O5yPergo4AQa1Tx1k119NWlAkAlRhzzcaY2+TqWfjCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=elo+XmVmnE/yMeqlECHLiqNjvAxxa7zHl8+qP8Ug9xEXRM3QNT5NWUgEIYRTgjkTw
	 lfxIkFIPHduA2qAywk2weuByyPDCqlR+AktRhqMBaVRmL2qYWL99Tk+x7kUpt2ZI3C
	 hb+o7qiCjL2kbSn/tIOc06Dz8X2eEP+wg3eMph04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b834a6b2decad004cfa1@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@qq.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 004/374] mptcp: fix uninit-value in mptcp_incoming_options
Date: Mon, 22 Jan 2024 15:54:20 -0800
Message-ID: <20240122235744.777885366@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 237ff253f2d4f6307b7b20434d7cbcc67693298b ]

Added initialization use_ack to mptcp_parse_option().

Reported-by: syzbot+b834a6b2decad004cfa1@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/options.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index aa4b0cf7c638..012e0e352276 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -103,6 +103,7 @@ static void mptcp_parse_option(const struct sk_buff *skb,
 			mp_opt->suboptions |= OPTION_MPTCP_DSS;
 			mp_opt->use_map = 1;
 			mp_opt->mpc_map = 1;
+			mp_opt->use_ack = 0;
 			mp_opt->data_len = get_unaligned_be16(ptr);
 			ptr += 2;
 		}
-- 
2.43.0



