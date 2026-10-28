Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208679;
	b=3xQVTx6VSZYGT3xUgcrYyM94aLv5YhC6dzD+Yqga+e4pwj8fp6p+cb9bXWRbxwOTnclV
	 VQTo8ZJ8Jq67p6OARAnQoy+ldKb+ISCGEmQvyM8f+AaXikyCiDVWwVyE2WNFw7gXTfi0M
	 23qGY2HykIY7VQWrGEOPaOjwjuB5d/JyvwClAvXSG/6VruRHxFf6rJOqQywI2tMt7MVXQ
	 8UpwLMVAuj6LUytmg8FmSTMIDcJJEI27UeTPeNOq/p4/yPDRbt8NUo+nBkIG85bMACQPj
	 SrLMmW9FCA9PtEgmY+P2lA++G6U4KI1L5gOCgIBIOXQ0hXjqj+PlraIg3u+0OcFbigw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208679;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JETXaGfqyfnhF3enVEuh3YZbzYdvvfbsSzs9ZxRXfvU=;
	b=loK1SHGGDM4ezle8nfwe2qu6JNuYrqD00D+8cwZrVxuhnsRAf4siAteRLLbMs3DF6BBR
	 bBk0LYIYxcsqAPVtHK4mGdFZN6UYN14HaANOapiY1FI7R6uCmAwvWPSGKETzsXaoyx2no
	 WXvQSKQWYLGMs6eZMseoUuB3v6kjCgrLMEvLrEOJydFC5UBSSYld6dwXeCzoXg68qB6ye
	 b0AI4otAj3ExVq4o/cbIofcS8opBlwt/BjbbsJuPnaL7BUJspC6b/9BhoFgiJ6o7LbbKj
	 R2JUSkJLSjjWfxShHAuvwy7y1uodMzmfk4ELs8zJEog3i7XpJ61Rj+zNT30MXAX0TOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xISk4GRS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1F1606A31D;
	Wed, 28 Oct 2026 17:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xISk4GRS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF051F031E2;
	Wed, 28 Oct 2026 17:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208679;
	bh=JETXaGfqyfnhF3enVEuh3YZbzYdvvfbsSzs9ZxRXfvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xISk4GRSwbaF67RG9emjKPKO6qc0YsKEo4O/tCc9xNa/363+oVxe2zUsaEy1p0mn/
	 RfTXMIucUPqPqNBlMugluAuKdetL00Ozc11Mysjftc1fqfAqQBZUnlmh/oiOxARRXi
	 OHoQVV/PrZGk8ii7kxotEAn+qa4yYfYD9j/ejCUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Subject: [PATCH 5.10 205/516] tty: serial: qcom_geni_serial: Keep console RX functional after deep idle
Date: Wed, 28 Oct 2026 17:55:57 +0100
Message-ID: <20261028170008.358961587@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>

commit 63ef71d1474b5417b5b2dec700cd251c44a570d9 upstream.

At baud rates up to 115200, the serial console uses only a 1 kBps keepalive
vote for the GENI_TO_CORE ("qup-core") ICC path. This vote keeps the path
active but does not request a QUP Core 2X clock rate.

When the CPU enters a deeper idle state, the missing Core clock vote can
leave the console RX path unresponsive.

Use the 19.2 MHz Core 2X vote at low baud rates, while retaining the 50 MHz
vote at higher baud rates, so that console RX remains functional after deep
idle transitions.

Fixes: 7cf563b2c846 ("tty: serial: qcom_geni_serial: Add interconnect support")
Cc: stable@kernel.org
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-correct-icc-bandwidth-vote-constants-v2-2-f78eb611204e@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/qcom_geni_serial.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -1017,9 +1017,8 @@ static void qcom_geni_serial_set_termios
 	 * Bump up BW vote on CPU and CORE path as driver supports FIFO mode
 	 * only.
 	 */
-	avg_bw_core = (baud > 115200) ? Bps_to_icc(CORE_2X_50_MHZ)
-						: GENI_DEFAULT_BW;
-	port->se.icc_paths[GENI_TO_CORE].avg_bw = avg_bw_core;
+	avg_bw_core = baud > 115200 ? CORE_2X_50_MHZ : CORE_2X_19_2_MHZ;
+	port->se.icc_paths[GENI_TO_CORE].avg_bw = Bps_to_icc(avg_bw_core);
 	port->se.icc_paths[CPU_TO_GENI].avg_bw = Bps_to_icc(baud);
 	geni_icc_set_bw(&port->se);
 


