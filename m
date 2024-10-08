Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68199192594;
	Tue,  8 Oct 2024 12:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391174; cv=none; b=kFjg9RLyWSNWIy1M2KVeeZWCjHVFy5FinIUt2Y/XTz1Qoux9tsc6LSLDS6WNlmrFQQiPs9LT2sLhXV2sH0lWbtegV/dFAPOqh03H52lAKrJrSjIqcizsVoYAS52eXQSqDUNfSTcDOPPiH0IQ82qh6ZgQBE/AQso/NQwt/6wrVSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391174; c=relaxed/simple;
	bh=Lymv25abTdwJenUGyue0XRF8v26qBXK0R35sUqkXxpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6Vfaa+d8iOu66/vvR4qB5sSI+E/wmyd8gek4ejX8S7j7i8uWGrnxTVdmd0e8OIB1YKWitESRUUvYHCmo9gW2QVJWR+34Kns1NIKaAFHeXitfW26yhXgOgXGnN38DBekUqV6n2DtslrhTQNtTnNdyzBTU7/uj02zp/obJnyAd4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqiL3AeJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqiL3AeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884E2C4CEC7;
	Tue,  8 Oct 2024 12:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391174;
	bh=Lymv25abTdwJenUGyue0XRF8v26qBXK0R35sUqkXxpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqiL3AeJcHbMlNlzdpVupH4OaQjOcmpl4HT6pf7rNLpLY69qrY9cB1Fi72Zf8nr23
	 ftlGrKwN/iZI0juFoHfjvBsSH15QEBz6/Gbkr/x+GQhsOuzuZO3EZtYGMS0F7RflDn
	 m/Mg4HNMX7vuwT+A0Xn8fJg0VmwY/V+mJjVTv+i0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhang jiao <zhangjiao2@cmss.chinamobile.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 030/558] selftests: netfilter: Add missing return value
Date: Tue,  8 Oct 2024 14:01:00 +0200
Message-ID: <20241008115703.409238023@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhang jiao <zhangjiao2@cmss.chinamobile.com>

[ Upstream commit 10dbd23633f0433f8d13c2803d687b36a675ef60 ]

There is no return value in count_entries, just add it.

Fixes: eff3c558bb7e ("netfilter: ctnetlink: support filtering by zone")
Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/netfilter/conntrack_dump_flush.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
index bd9317bf5adaf..dc056fec993bd 100644
--- a/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
+++ b/tools/testing/selftests/net/netfilter/conntrack_dump_flush.c
@@ -207,6 +207,7 @@ static int conntrack_data_generate_v6(struct mnl_socket *sock,
 static int count_entries(const struct nlmsghdr *nlh, void *data)
 {
 	reply_counter++;
+	return MNL_CB_OK;
 }
 
 static int conntracK_count_zone(struct mnl_socket *sock, uint16_t zone)
-- 
2.43.0



