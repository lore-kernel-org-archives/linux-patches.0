Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060671;
	b=lHEE9f6dKy5Ess/VaksVsIPIFNviEg2Bj2WfeWIRZjoPw067Kc/BRB7Algie+G2CSP/B
	 /fH57jzQMy3UBUW5b2myHePHRApXp1qsivhqejYyy8yj6CbJqS3Jx026qEzFR5tVT1NP4
	 FnJjq6TPZKR1MH2HCbl968wFPW15vSQn57BzrwLuml5yFEE9DAIc982GDmzgHPyinaS7I
	 nEDvZmaNOKihKx5NwAz3kwFwupTaDATo7IOTGi7fEZpJwtsV9J2fVCnzepNHKtawP02is
	 i4WF4b4tskTXZTvaXjkBoo2JeUTNGRifCzUfb4YGEYRkSX5qf1IQCGi2Vkxpu/ivWYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wo7L+XurdlPUxmJIjxVUPQwLx4souar/PWxjdPC9Lq8=;
	b=q3o85TcZWJ0qgUwUs8vb/3xl2yUNGc2eLp1oWf285QhSwVvymgnHwXIgQSfN6DM/NTBw
	 ufQSJU5+73IwNpGRBQDMo2sBI0Xa0h+BwJSWFsJ9m5qaait49oIOfUOOlAJXKB8zLXIoo
	 xcx/nXIlkn+PZSbD1SowodU1jvRtbIGpp3lag02OI7f15PBZ9HlzePTX8HMoA5nXg/aLy
	 jNRXs1mjP85V7M3ii3vWHLVMa0ncBcNP0b/LnrJKdCF9/nmKgON1GHmiIym4EXmPnUk7F
	 KrpOahcDz/IXqneYff1iuk826lKTVQNc4F6h1WhK1k9PeWnEQe/3JhB8kkQX4521vBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kFJtcA7+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB5A606A326;
	Sat,  7 Nov 2026 14:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kFJtcA7+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4831E1F0089F;
	Sat,  7 Nov 2026 14:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060671;
	bh=wo7L+XurdlPUxmJIjxVUPQwLx4souar/PWxjdPC9Lq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kFJtcA7+PwvrJ+OmW1040S2xsMsLGn1Z+Db8BCrHobb6AVbbkpcXl96NPXdojGnc9
	 o73hAEp7+4FbBA8p08ko+J/EtcWbLygXEf0OgyjPBVBrIhf8I7ewrtu65cPcglVig3
	 WkdducHxZ8FRsltsq/EpOe/Go63aQLK+K1nUD8r8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Bukte <rahul.bukte@sony.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0107/1536] serial: 8250: force synchronous probe for the ISA and PNP drivers
Date: Sat,  7 Nov 2026 08:35:23 -0500
Message-ID: <20261107135000.679928982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Bukte <rahul.bukte@sony.com>

[ Upstream commit 31e11af34e2c7cc61e25533ab877b1f9cc3eb528 ]

On x86_64 defconfig, booting with driver_async_probe=serial hangs in early
init. The 8250 PNP driver is put onto the async probe pool.
serial8250_register_8250_port() runs in a kworker concurrently with the
ISA registration done from the serial8250_init() initcall resulting in a
deadlock or NULL dereference.

  - Deadlock: serial_core_register_port() holds port_mutex across
    serial_core_add_one_port()
        uart_configure_port()
            autoconfig_irq()
                probe_irq_on()
                    async_synchronize_full(),
    which waits for the async probe pool to drain.

    The async PNP worker reaches the "port already in use" check and
    tries to unregister it.
    serial8250_register_8250_port()
        uart_remove_one_port()
            serial_core_unregister_port()
    This blocks on port_mutex.
    The init thread waits for the worker and the worker waits for the
    init thread.

  - NULL deref: when the worker instead observes a slot whose port.dev
    is set but whose port_dev has not yet been populated, it hits the
    null pointer on the call to serial_core_get_ctrl_dev() in
    serial_core_unregister_port().

Signed-off-by: Rahul Bukte <rahul.bukte@sony.com>
Link: https://patch.msgid.link/20260610054130.2825182-1-rahul.bukte@sony.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_platform.c | 1 +
 drivers/tty/serial/8250/8250_pnp.c      | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_platform.c b/drivers/tty/serial/8250/8250_platform.c
index be7ff07cbdd00..872d3dc89d7f6 100644
--- a/drivers/tty/serial/8250/8250_platform.c
+++ b/drivers/tty/serial/8250/8250_platform.c
@@ -291,6 +291,7 @@ static struct platform_driver serial8250_isa_driver = {
 	.driver		= {
 		.name	= "serial8250",
 		.acpi_match_table = acpi_platform_serial_table,
+		.probe_type = PROBE_FORCE_SYNCHRONOUS,
 	},
 };
 
diff --git a/drivers/tty/serial/8250/8250_pnp.c b/drivers/tty/serial/8250/8250_pnp.c
index 7c06ae79d8e23..6f4e91758d4fd 100644
--- a/drivers/tty/serial/8250/8250_pnp.c
+++ b/drivers/tty/serial/8250/8250_pnp.c
@@ -531,6 +531,7 @@ static struct pnp_driver serial_pnp_driver = {
 	.remove		= serial_pnp_remove,
 	.driver         = {
 		.pm     = pm_sleep_ptr(&serial_pnp_pm_ops),
+		.probe_type = PROBE_FORCE_SYNCHRONOUS,
 	},
 	.id_table	= pnp_dev_table,
 };
-- 
2.53.0



