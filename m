Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829439;
	b=zJxm0ENj9dKEyY4jIq3nrODxoXgjW3pbbD/cUJHZZO8Ib8H4DuLthjT8R2nTbTyN5V7D
	 IyMbZD9cZXvSs2MMAsdkQ5naVqq66R6CCaOnD5rbdQKz9xD9aw42KMo/s93c0wYr0FwPa
	 JfYauv0/PeF27rrK1qtmy2B8XNvW4RochDkgjwdIgQ4k5S4hCGdMeeL5qWR4hui+hKZ2c
	 c8JwHS4HltyEJz+y5eOfB7PQrAfVvxo5MggDxQ8rUint2hCyLggDO/igDT9eE6kCnXAdH
	 ICBR64wWXXHx368S6fhq8NoTJ3rIf/o4JLn0pZDW83HGLEysVx7qHRABg629iVF7Bxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jGbn6JM8Qhc5ydMgCki/Xz0bgNQH+Mt8goxLxRjLIvw=;
	b=pNlNm0nv1hArlAnI14DTzN5SZrcS9RSdKktNSzwxupAoZ9ETlah4+y54h+sjC3DscXLE
	 uYDpeowCxue+8D1JXajRsM3xnJMnUmVxv34xLItssj+NV/zz7qBnutMTBjjvV/wQsEz6r
	 WjEg5ya/cvcaMbGkaSTM7GZGxCvnVYNTpFaTiR+qB3BHq+9iN5Vd0jIqRoDfNWipd8qgk
	 oYQ70GYiyU3D3blO+dBl0qYCamhkhN6MJdoE6KSMmT7aYMxrVQYgZFw17fP+ZvSGNBb70
	 oVHO8sDv5IVuYKrAoAjG0zVNGMN+uPe1GREEk2fn8Xc4zMb+IeZzl776siSuShHNutQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tcT4JXIa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F423606A840;
	Wed,  4 Nov 2026 21:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tcT4JXIa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE831F0093A;
	Wed,  4 Nov 2026 21:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829439;
	bh=jGbn6JM8Qhc5ydMgCki/Xz0bgNQH+Mt8goxLxRjLIvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tcT4JXIaGTjqxupDAkk02OezwIr1/UI4vrpsCRK5VhMq4hQvUy2DztVnCubJhsq/b
	 YTTlNxPbg7JQDZwl1anek9jeGD6qEi9SuT7lVUKm5wVlBn15HlR+vB2LVLpXh6zrau
	 hkJ1RZn5lsJ1OtZ9/P/rtvt+IlzBxFjadHdTFyqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Bukte <rahul.bukte@sony.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0126/1005] serial: 8250: force synchronous probe for the ISA and PNP drivers
Date: Wed,  4 Nov 2026 15:57:39 -0500
Message-ID: <20261104211047.209057711@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fe7ec440ffa58..69d8720fb65bf 100644
--- a/drivers/tty/serial/8250/8250_platform.c
+++ b/drivers/tty/serial/8250/8250_platform.c
@@ -287,6 +287,7 @@ static struct platform_driver serial8250_isa_driver = {
 	.driver		= {
 		.name	= "serial8250",
 		.acpi_match_table = acpi_platform_serial_table,
+		.probe_type = PROBE_FORCE_SYNCHRONOUS,
 	},
 };
 
diff --git a/drivers/tty/serial/8250/8250_pnp.c b/drivers/tty/serial/8250/8250_pnp.c
index 7a837fdf9df13..3f41a9d6cb273 100644
--- a/drivers/tty/serial/8250/8250_pnp.c
+++ b/drivers/tty/serial/8250/8250_pnp.c
@@ -521,6 +521,7 @@ static struct pnp_driver serial_pnp_driver = {
 	.remove		= serial_pnp_remove,
 	.driver         = {
 		.pm     = pm_sleep_ptr(&serial_pnp_pm_ops),
+		.probe_type = PROBE_FORCE_SYNCHRONOUS,
 	},
 	.id_table	= pnp_dev_table,
 };
-- 
2.53.0



