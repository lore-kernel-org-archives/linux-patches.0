Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2118.outbound.protection.outlook.com [40.107.247.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E212C8E5
	for <patches@lists.linux.dev>; Mon, 15 May 2023 15:38:45 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CfUFnaULvULXApaQO0MwB/GqmzlE5MGM22SLmsTWnC6sdimbZ7NL0aXC2T9alcGZXv9W538ERcsZ63ArLntZ0erecR/bC3EHZ+lYDEVZUb5Qvaf2kJcxXQlrbxK2Q0R4T9lPclM5J76+r5lBDKQVz6QxH/Rnp0jfeSbGVyQyJmLS72NjTNsoY214MFf5l+w/xyPF8876upTfOPygwppU6pOw73h069qGG5XpqlJfKM49uocc2OffgHKE6sEEEN+VMOpmY9yrSrKcLf58mQYDbdLGpxG27b27piJ+XQIg9ZwAQDLN4sLA37DeQ6lAIutfM8T8SEdJG7muYj7jnq8aVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nv2b0fk9ae/uQ2LOAxBufFsqY9RTSQDrO/Xoa7Xoanw=;
 b=kxnWEKpME/ikd0d1TQF4uajV4iEYximtw9uUq/8si9nxkVn0UlDs/4hswj6oryt9Ra+Lmyd8KHvyrAIBaQlmp1nAzdz7VId5fAgsv4iWqNoNzWOgHAEprTyiSasxd8UgQ/l5H5trkpCYF5hcpEtqIVF38BZ6neAyW7iifxbrs2353j+40TC3plvAO0dul5ojfVIR1dIwrd5f4DAO/ZiTul4k/Wx9cMb8uL9lW1y+NCkea1FjDQNn7aqSMBJtLsHL5RzxH2Fr/AAUexGddWmZAH5ds3YkpMD6a5eb0j+fxBka6NyG4T9Xyrio7WkS3u6J//cdT6kGbrJ1OrkuoXz0WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 52.137.61.15) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=sma.de;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=sma.de; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sma.de; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nv2b0fk9ae/uQ2LOAxBufFsqY9RTSQDrO/Xoa7Xoanw=;
 b=wsIbFj+p7/n2baNUfeNaX4xVzlpgBu2IRi1UkBbF322+znFAGWcvBa6MmrcX/M5+ZDARCUrzkg8t0oPXm2nA6jcFpxWx/sFzGNFvBfq6UfaUARkLkcE1u5ozUCjuH6igeEa4N9aRQegt+rB/oWgDPct9MsLNaIC+hApD+/Z/Eoc=
Received: from FR0P281CA0006.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:15::11)
 by AM9PR04MB7556.eurprd04.prod.outlook.com (2603:10a6:20b:2df::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19; Mon, 15 May
 2023 15:38:41 +0000
Received: from VI1EUR02FT054.eop-EUR02.prod.protection.outlook.com
 (2603:10a6:d10:15:cafe::b4) by FR0P281CA0006.outlook.office365.com
 (2603:10a6:d10:15::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.14 via Frontend
 Transport; Mon, 15 May 2023 15:38:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 52.137.61.15)
 smtp.mailfrom=sma.de; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=sma.de;
Received-SPF: Pass (protection.outlook.com: domain of sma.de designates
 52.137.61.15 as permitted sender) receiver=protection.outlook.com;
 client-ip=52.137.61.15; helo=mailrelay01.sma.de; pr=C
Received: from mailrelay01.sma.de (52.137.61.15) by
 VI1EUR02FT054.mail.protection.outlook.com (10.13.60.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.14 via Frontend Transport; Mon, 15 May 2023 15:38:41 +0000
Received: from localhost.localdomain (172.26.8.21) by azwewpexc-1.sma.de
 (172.26.34.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.26; Mon, 15 May
 2023 17:38:39 +0200
From: Felix Riemann <svc.sw.rte.linux@sma.de>
To: <gregkh@linuxfoundation.org>
CC: Felix Riemann <felix.riemann@sma.de>, <jarkko@kernel.org>,
	<l.sanfilippo@kunbus.com>, <patches@lists.linux.dev>, <sashal@kernel.org>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH 5.15 070/371] tpm, tpm_tis: Claim locality before writing interrupt registers
Date: Mon, 15 May 2023 17:37:59 +0200
Message-ID: <20230515153759.2072-1-svc.sw.rte.linux@sma.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230508094814.897191675@linuxfoundation.org>
References: <20230508094814.897191675@linuxfoundation.org>
Reply-To: Felix Riemann <felix.riemann@sma.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.26.8.21]
X-ClientProxiedBy: azwewpexc-2.sma.de (172.26.34.10) To azwewpexc-1.sma.de
 (172.26.34.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1EUR02FT054:EE_|AM9PR04MB7556:EE_
X-MS-Office365-Filtering-Correlation-Id: cfa24fac-0060-4d84-c936-08db555a7598
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cgrI66UwYbKHdyUkrG/ve5JNsm6WcQC0Y8jnu2j+wg4eClMHwwaujvn5+xFEdgWk3eBnmuSi/tOlg+s4Ybf7PNZvQAeCHVIAFqvr3T1hzKAl3JWLe04ZH+rk9YNMVtDxr+O2WuIfAQzni8YF7azZHlSa2gwNxinmRdfLWu6D/OywEjDfioxkflj0gtzS3MoWS1cSLmRYL90DGc6NUNUZGrCWyVpTskysw9mQD7paAXKPyl2IXCdafM0rej8/bM1ddXzV+QoQFK/3ncTzCCFGFyYZrCOf6tdDKPj665OZCvSYrIkUn37OKjrx8wlZbOU2Jz+uZoStmjOv4VI86DeMoNTPKlqxH48Ub3cxjn2Nb95w6XHefaFcNIFe5QVEvmWXkXmUY0yNOkHrhKLY1EfPaUgDygnZHCWnsbUaXz1ukjqor4IrndZXuk0YlLhg1XoZRTfziyzqIEQXKK8AU2Mz3VrqSitZSaiXspn3H2RjnRT3gdVtmdRHu04XMCAXt4tQNktFjj83q3C5Ly1+0DBeE+RK3Z05adl1eHlI7V98Pb99a+3hqJfIMltf2ZoRqmrD8zOL0GifI1BewomjCe9bDKhSiEH6yjFBb65r+xotGNndz3cG2Uge8wKgYs5Etd4VIrDFgv1bvtpMRBiSJnMB+qpj5mR5yYvFyhfc/8IAx5ao/gg02few6EYpdzF9ozOGfA/UCPL3v5FxR4fZN+fPndNTPbUgTZLHL+4BBA5fI5U=
X-Forefront-Antispam-Report:
	CIP:52.137.61.15;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mailrelay01.sma.de;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199021)(46966006)(36840700001)(186003)(8676002)(1076003)(83380400001)(2616005)(316002)(2906002)(47076005)(336012)(36860700001)(40480700001)(4326008)(45080400002)(41300700001)(426003)(6916009)(6666004)(70586007)(70206006)(54906003)(16526019)(5660300002)(26005)(478600001)(966005)(8936002)(356005)(82310400005)(36756003)(103116003)(86362001)(81166007)(82740400003)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: sma.de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 15:38:41.0953
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cfa24fac-0060-4d84-c936-08db555a7598
X-MS-Exchange-CrossTenant-Id: a059b96c-2829-4d11-8837-4cc1ff84735d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=a059b96c-2829-4d11-8837-4cc1ff84735d;Ip=[52.137.61.15];Helo=[mailrelay01.sma.de]
X-MS-Exchange-CrossTenant-AuthSource:
	VI1EUR02FT054.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7556

Hi!

> [ Upstream commit 15d7aa4e46eba87242a320f39773aa16faddadee ]
> 
> In tpm_tis_probe_single_irq() interrupt registers TPM_INT_VECTOR,
> TPM_INT_STATUS and TPM_INT_ENABLE are modified to setup the interrupts.
> Currently these modifications are done without holding a locality thus they
> have no effect. Fix this by claiming the (default) locality before the
> registers are written.
> 
> Since now tpm_tis_gen_interrupt() is called with the locality already
> claimed remove locality request and release from this function.

On systems with SPI-connected TPM and the interrupt still configured
(despite it not working before) this may introduce a kernel crash.
The issue is that it will now trigger an SPI transfer (which will wait) 
from the IRQ handler:

BUG: scheduling while atomic: systemd-journal/272/0x00010001
Modules linked in: spi_fsl_lpspi
CPU: 0 PID: 272 Comm: systemd-journal Not tainted 5.15.111-06679-g56b9923f2840 #50
Call trace:
 dump_backtrace+0x0/0x1e0
 show_stack+0x18/0x40
 dump_stack_lvl+0x68/0x84
 dump_stack+0x18/0x34
 __schedule_bug+0x54/0x70
 __schedule+0x664/0x760
 schedule+0x88/0x100
 schedule_timeout+0x80/0xf0
 wait_for_completion_timeout+0x80/0x10c
 fsl_lpspi_transfer_one+0x25c/0x4ac [spi_fsl_lpspi]
 spi_transfer_one_message+0x22c/0x440
 __spi_pump_messages+0x330/0x5b4
 __spi_sync+0x230/0x264
 spi_sync_locked+0x10/0x20
 tpm_tis_spi_transfer+0x1ec/0x250
 tpm_tis_spi_read_bytes+0x14/0x20
 tpm_tis_spi_read32+0x38/0x70
 tis_int_handler+0x48/0x15c
 *snip*

The immediate error is fixable by also picking 0c7e66e5fd ("tpm, tpm_tis: 
Request threaded interrupt handler") from the same patchset[1]. However, as
the driver's IRQ test logic is still faulty it will fail the check and fall
back to the polling behaviour without actually disabling the IRQ in hard-
and software again. For this at least e644b2f498 ("tpm, tpm_tis: Enable 
interrupt test") and 0e069265bc ("tpm, tpm_tis: Claim locality in interrupt
handler") are necessary.

At this point 9 of the set's 14 patches are applied and I am not sure
whether it's better to pick the remaining five patches as well or just
revert the initial six patches. Especially considering there were initially
no plans to submit these patches to stable[2] and the IRQ feature was (at
least on SPI) not working before.

Regards,

Felix

[1] https://lore.kernel.org/lkml/20221124135538.31020-1-LinoSanfilippo@gmx.de/
[2] https://lore.kernel.org/lkml/CS48ZBNWI6T9.1CU08I6KDVM65@suppilovahvero/
