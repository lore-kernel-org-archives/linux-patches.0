Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050845;
	b=IT3/ax0Fa8ssPIvu4wt7YiHp+pVrQwIE7W1Pwe8bpCcJS7eFL6X9g2rrvBuPDZWepvwW
	 algU9vkBCGeGAJP+N5kVDvn8BhZ/WKYtbfEyi0Je6iowUbqUhzIWN3i33ZOzhGKUOOst0
	 0Q38Y4ouhNHi/xt0Ycd8DpxL4i3KkyD+WQNqRQBLACkIngdRsAJIEIjtcApZDP3IuIh+M
	 3wM2IjVRIfqsHLO+wdJja9DO14JfH12dJWfCqvmelwqd2ncvKtQ/1ZqHcpPpxx62xfYph
	 FgO3CdRapcPLSazyPjIvsXzBcccQ1FeTYMnX21mJQEI5jhyBhnbwp46viHxEkTalpZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050845;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CAN3nkKaLMjiIWhMXT00bWuGYITLnTQyPGT+mmmJ1iU=;
	b=DNwj5Qu4M6qWSe0/IFQWH0RXE3X4oHt4V8k91rGpMnzlTuGo16mkXgRJQ+OU/oKJREHT
	 MW9Hl4rnauY3pQA1yvWG1NPmlZbz8AsFaf2pIAVCHiLYQeWGFRiFg9RJPKjSi0bR0CysB
	 X0JJczYOflZWzLhbaOZ1OM+sYviXNdYPuQQhiP+kEZ61LVW+XJFLcXak7iPH7dDzV7oGW
	 +I78fglb/6uRbKja+QHCFM7SsrepPCBKc7lHo2G0ikq+3YGr2ODfB9ZY+japBquQVvz1z
	 K/UbutmDw+Prj4f+2gOgcTBRcu4mC/xpSGUbbUZAb8UFhoT/M1EQbZb0FIBqNwt+FvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tCHzkBeP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF56B606A320;
	Thu, 19 Nov 2026 01:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tCHzkBeP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C15A1F000C5;
	Thu, 19 Nov 2026 01:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050845;
	bh=CAN3nkKaLMjiIWhMXT00bWuGYITLnTQyPGT+mmmJ1iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tCHzkBeP/kzE6MbMpoAoLgYiNziCqyAhsW3H6Kzh1ndtLSnBmS/ln85/tByW9kksU
	 eh7/YfLRJdhEUssVlHen6A6/tje9ucadzEpsO/QOvenphaFpS/TV8yhUA+5cc6xaEC
	 5Y/aPJTJwbDTeYU3wFylwnQsqZcrU4H4lSzFn2aU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengjie Zhang <zhangpengjie2@huawei.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	lihuisong@huawei.com,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 2854/2857] ACPI: PCC: Fix race condition by removing static qualifier
Date: Wed, 18 Nov 2026 16:04:48 +0100
Message-ID: <20261118150344.341368440@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengjie Zhang <zhangpengjie2@huawei.com>

commit f103fa127c93016bcd89b05d8e11dc1a84f6990d upstream.

Local variable 'ret' in acpi_pcc_address_space_setup() is currently
declared as 'static'. This can lead to race conditions in a
multithreaded environment.

Remove the 'static' qualifier to ensure that 'ret' will be allocated
directly on the stack as a local variable.

Fixes: a10b1c99e2dc ("ACPI: PCC: Setup PCC Opregion handler only if platform interrupt is available")
Signed-off-by: Pengjie Zhang <zhangpengjie2@huawei.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Acked-by: lihuisong@huawei.com
Cc: 6.2+ <stable@vger.kernel.org> # 6.2+
[ rjw: Changelog edits ]
Link: https://patch.msgid.link/20251210132634.2050033-1-zhangpengjie2@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_pcc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/acpi_pcc.c
+++ b/drivers/acpi/acpi_pcc.c
@@ -53,7 +53,7 @@ acpi_pcc_address_space_setup(acpi_handle
 	struct pcc_data *data;
 	struct acpi_pcc_info *ctx = handler_context;
 	struct pcc_mbox_chan *pcc_chan;
-	static acpi_status ret;
+	acpi_status ret;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)


