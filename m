Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29DC446C9;
	Tue, 20 Feb 2024 21:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464730; cv=none; b=vB4mgQFMOGaglphD5Dy0e2+7DlRlPrWicTlSEN/KAped3YpnOCy42SqsxGXv2ocn3IE2sp+h7Co3lOQTkSW9SGpDmQOiodqCZIeNQGImncFT+6u4VKzRXSw9aFLL34+vItX6Z7RxZ+1M/ern9eRlSSDyr5PnNCDVP75DbF89Xrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464730; c=relaxed/simple;
	bh=Llx8ENICulKwg/JoHDQR5+RQkfIIWtwSa6kwOK+Wzzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=habmnthezdfthLX63JO/Oe/89Y9QOnCky5JwYs1y5+kTia9Kp0qcvTJaqWCHvz4YBpxEbA5aS2EOPeZ02No6aogD+b2gR+RfoDPQslFa8ronWX7nEo8EocQqrFPs+NL7fL9Yl9LHJWF9F3k4YfMWXCDA0+M1rLjZwZr2pQdvupk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dDyhUmsb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDyhUmsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E8BC433F1;
	Tue, 20 Feb 2024 21:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464730;
	bh=Llx8ENICulKwg/JoHDQR5+RQkfIIWtwSa6kwOK+Wzzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dDyhUmsbPI8ESrZinNeqp6IRyN7Ayx9ojD30Y7trsLu2IeoyIvtkYQeOBYGb1uRRH
	 +tQzKkdX06PkF76L/JzOvAICYNnjZlhccFut9FmBGEn496+f1C6KHS0LHt+rNosJWg
	 57JNOesskfAO80XacenMjpDQRaRqc87wnWCVDtZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.7 118/309] selftests: mptcp: add missing kconfig for NF Filter in v6
Date: Tue, 20 Feb 2024 21:54:37 +0100
Message-ID: <20240220205636.870598764@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 8c86fad2cecdc6bf7283ecd298b4d0555bd8b8aa upstream.

Since the commit mentioned below, 'mptcp_join' selftests is using
IPTables to add rules to the Filter table for IPv6.

It is then required to have IP6_NF_FILTER KConfig.

This KConfig is usually enabled by default in many defconfig, but we
recently noticed that some CI were running our selftests without them
enabled.

Fixes: 523514ed0a99 ("selftests: mptcp: add ADD_ADDR IPv6 test cases")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240131-upstream-net-20240131-mptcp-ci-issues-v1-3-4c1c11e571ff@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/config |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/net/mptcp/config
+++ b/tools/testing/selftests/net/mptcp/config
@@ -25,6 +25,7 @@ CONFIG_IP_MULTIPLE_TABLES=y
 CONFIG_IP_NF_FILTER=m
 CONFIG_IP_NF_TARGET_REJECT=m
 CONFIG_IPV6_MULTIPLE_TABLES=y
+CONFIG_IP6_NF_FILTER=m
 CONFIG_NET_ACT_CSUM=m
 CONFIG_NET_ACT_PEDIT=m
 CONFIG_NET_CLS_ACT=y


